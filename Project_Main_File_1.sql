/*===========================================================
 PROJECT : MOTOR INSURANCE MANAGEMENT SYSTEM
 TABLES 1 TO 25
===========================================================*/

DROP DATABASE IF EXISTS motor_insurance_db;
CREATE DATABASE motor_insurance_db;
USE motor_insurance_db;

-- ==========================================
-- 1. COUNTRY MASTER
-- ==========================================
CREATE TABLE mi_country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE,
    country_code VARCHAR(10) UNIQUE,
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    added_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 2. STATE MASTER
-- ==========================================
CREATE TABLE mi_state (
    state_id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    added_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(country_id)
    REFERENCES mi_country(country_id)
);

-- ==========================================
-- 3. CITY MASTER
-- ==========================================
CREATE TABLE mi_city (
    city_id INT AUTO_INCREMENT PRIMARY KEY,
    state_id INT NOT NULL,
    city_name VARCHAR(100) NOT NULL,
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    added_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(state_id)
    REFERENCES mi_state(state_id)
);

-- ==========================================
-- 4. REGION MASTER
-- ==========================================
CREATE TABLE mi_region (
    region_id INT AUTO_INCREMENT PRIMARY KEY,
    region_name VARCHAR(50) UNIQUE,
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    added_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 5. VEHICLE MAKE
-- ==========================================
CREATE TABLE mi_vehicle_make (
    make_id INT AUTO_INCREMENT PRIMARY KEY,
    make_name VARCHAR(100) UNIQUE NOT NULL,
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    added_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 6. VEHICLE MODEL
-- ==========================================
CREATE TABLE mi_vehicle_model (
    model_id INT AUTO_INCREMENT PRIMARY KEY,
    make_id INT NOT NULL,
    model_name VARCHAR(100),
    manufacture_year YEAR,
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    FOREIGN KEY(make_id)
    REFERENCES mi_vehicle_make(make_id)
);

-- ==========================================
-- 7. VEHICLE COLOR
-- ==========================================
CREATE TABLE mi_vehicle_color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    color_name VARCHAR(50),
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE'
);

-- ==========================================
-- 8. VEHICLE BODY
-- ==========================================
CREATE TABLE mi_vehicle_body (
    body_id INT AUTO_INCREMENT PRIMARY KEY,
    body_type VARCHAR(60),
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE'
);

-- ==========================================
-- 9. VEHICLE CATEGORY
-- ==========================================
CREATE TABLE mi_vehicle_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100),
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE'
);

-- ==========================================
-- 10. PRODUCT MASTER
-- ==========================================
CREATE TABLE mi_product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    coverage_type VARCHAR(100),
    base_premium DECIMAL(12,2),
    gst_percent DECIMAL(5,2),
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE'
);

-- ==========================================
-- 11. USER MASTER
-- ==========================================
CREATE TABLE mi_user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    gender ENUM('Male','Female','Other'),
    dob DATE,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    mobile VARCHAR(20),
    address VARCHAR(250),
    city_id INT,
    state_id INT,
    country_id INT,
    national_id VARCHAR(30) UNIQUE,
    nationality VARCHAR(80),
    user_role ENUM('ADMIN','UNDERWRITER','BROKER','OPERATION','AGENT'),
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    added_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(city_id) REFERENCES mi_city(city_id),
    FOREIGN KEY(state_id) REFERENCES mi_state(state_id),
    FOREIGN KEY(country_id) REFERENCES mi_country(country_id)
);

-- ==========================================
-- 12. LOGIN TABLE
-- ==========================================
CREATE TABLE mi_login (
    login_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    username VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255),
    last_login DATETIME,
    login_status ENUM('ACTIVE','BLOCKED') DEFAULT 'ACTIVE',
    FOREIGN KEY(user_id)
    REFERENCES mi_user(user_id)
);

-- ==========================================
-- 13. BROKER
-- ==========================================
CREATE TABLE mi_broker (
    broker_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    broker_name VARCHAR(150),
    organization_name VARCHAR(150),
    license_number VARCHAR(100) UNIQUE,
    commission_rate DECIMAL(5,2),
    prepaid_balance DECIMAL(15,2),
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    FOREIGN KEY(user_id)
    REFERENCES mi_user(user_id)
);

-- ==========================================
-- 14. CUSTOMER TABLE
-- ==========================================
CREATE TABLE mi_customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    gender ENUM('Male','Female','Other'),
    dob DATE,
    email VARCHAR(150) UNIQUE,
    mobile VARCHAR(20),
    address VARCHAR(255),
    city_id INT,
    state_id INT,
    country_id INT,
    national_id VARCHAR(30) UNIQUE,
    occupation VARCHAR(100),
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(city_id) REFERENCES mi_city(city_id),
    FOREIGN KEY(state_id) REFERENCES mi_state(state_id),
    FOREIGN KEY(country_id) REFERENCES mi_country(country_id)
);

-- ==========================================
-- 15. VEHICLE TABLE
-- ==========================================
CREATE TABLE mi_vehicle (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    make_id INT NOT NULL,
    model_id INT NOT NULL,
    color_id INT,
    body_id INT,
    category_id INT,
    registration_no VARCHAR(30) UNIQUE,
    engine_no VARCHAR(50) UNIQUE,
    chassis_no VARCHAR(50) UNIQUE,
    manufacture_year YEAR,
    purchase_date DATE,
    vehicle_value DECIMAL(12,2),
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    FOREIGN KEY(customer_id) REFERENCES mi_customer(customer_id),
    FOREIGN KEY(make_id) REFERENCES mi_vehicle_make(make_id),
    FOREIGN KEY(model_id) REFERENCES mi_vehicle_model(model_id),
    FOREIGN KEY(color_id) REFERENCES mi_vehicle_color(color_id),
    FOREIGN KEY(body_id) REFERENCES mi_vehicle_body(body_id),
    FOREIGN KEY(category_id) REFERENCES mi_vehicle_category(category_id)
);

-- ==========================================
-- 16. QUOTE TABLE
-- ==========================================
CREATE TABLE mi_quote (
    quote_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    vehicle_id INT,
    broker_id INT,
    product_id INT,
    quote_date DATE,
    coverage_type VARCHAR(100),
    basic_premium DECIMAL(12,2),
    addon_amount DECIMAL(12,2),
    tax_amount DECIMAL(12,2),
    total_premium DECIMAL(12,2),
    quote_status ENUM('NEW','APPROVED','REJECTED','EXPIRED') DEFAULT 'NEW',
    FOREIGN KEY(customer_id) REFERENCES mi_customer(customer_id),
    FOREIGN KEY(vehicle_id) REFERENCES mi_vehicle(vehicle_id),
    FOREIGN KEY(broker_id) REFERENCES mi_broker(broker_id),
    FOREIGN KEY(product_id) REFERENCES mi_product(product_id)
);

-- ==========================================
-- 17. PREMIUM CONFIGURATION
-- ==========================================
CREATE TABLE mi_premium_config (
    config_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    product_id INT,
    min_vehicle_value DECIMAL(12,2),
    max_vehicle_value DECIMAL(12,2),
    premium_percentage DECIMAL(5,2),
    gst_percentage DECIMAL(5,2),
    effective_from DATE,
    effective_to DATE,
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    FOREIGN KEY(category_id) REFERENCES mi_vehicle_category(category_id),
    FOREIGN KEY(product_id) REFERENCES mi_product(product_id)
);

-- ==========================================
-- 18. PREMIUM CALCULATION
-- ==========================================
CREATE TABLE mi_premium (
    premium_id INT AUTO_INCREMENT PRIMARY KEY,
    quote_id INT,
    base_premium DECIMAL(12,2),
    addon_premium DECIMAL(12,2),
    gst_amount DECIMAL(12,2),
    discount_amount DECIMAL(12,2),
    final_premium DECIMAL(12,2),
    calculated_on DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(quote_id) REFERENCES mi_quote(quote_id)
);

-- ==========================================
-- 19. POLICY TABLE
-- ==========================================
CREATE TABLE mi_policy (
    policy_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_number VARCHAR(50) UNIQUE,
    quote_id INT,
    issue_date DATE,
    start_date DATE,
    expiry_date DATE,
    policy_status ENUM('ACTIVE','EXPIRED','CANCELLED') DEFAULT 'ACTIVE',
    FOREIGN KEY(quote_id) REFERENCES mi_quote(quote_id)
);

-- ==========================================
-- 20. PAYMENT TABLE
-- ==========================================
CREATE TABLE mi_payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT,
    payment_date DATETIME,
    payment_method ENUM('CASH','CARD','UPI','NETBANKING'),
    currency VARCHAR(20),
    amount DECIMAL(12,2),
    payment_status ENUM('SUCCESS','FAILED','PENDING') DEFAULT 'PENDING',
    transaction_reference VARCHAR(100),
    FOREIGN KEY(policy_id) REFERENCES mi_policy(policy_id)
);

-- ==========================================
-- 21. CLAIM TABLE
-- ==========================================
CREATE TABLE mi_claim (
    claim_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT,
    claim_date DATE,
    accident_date DATE,
    claim_amount DECIMAL(12,2),
    approved_amount DECIMAL(12,2),
    claim_status ENUM('PENDING','APPROVED','REJECTED','HOLD') DEFAULT 'PENDING',
    remarks VARCHAR(255),
    FOREIGN KEY(policy_id) REFERENCES mi_policy(policy_id)
);

-- ==========================================
-- 22. ENDORSEMENT TABLE
-- ==========================================
CREATE TABLE mi_endorsement (
    endorsement_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT,
    endorsement_date DATE,
    endorsement_type VARCHAR(100),
    old_value VARCHAR(255),
    new_value VARCHAR(255),
    remarks VARCHAR(255),
    FOREIGN KEY(policy_id) REFERENCES mi_policy(policy_id)
);

-- ==========================================
-- 23. RENEWAL TABLE
-- ==========================================
CREATE TABLE mi_renewal (
    renewal_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT,
    renewal_date DATE,
    renewed_until DATE,
    renewal_premium DECIMAL(12,2),
    renewal_status ENUM('PENDING','COMPLETED','FAILED'),
    FOREIGN KEY(policy_id) REFERENCES mi_policy(policy_id)
);

-- ==========================================
-- 24. CREDIT / DEBIT NOTE TABLE
-- ==========================================
CREATE TABLE mi_financial_note (
    note_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT,
    note_type ENUM('CREDIT','DEBIT'),
    note_number VARCHAR(50) UNIQUE,
    note_date DATE,
    amount DECIMAL(12,2),
    remarks VARCHAR(255),
    FOREIGN KEY(policy_id) REFERENCES mi_policy(policy_id)
);

-- ==========================================
-- 25. AUDIT LOG TABLE
-- ==========================================
CREATE TABLE mi_audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    table_name VARCHAR(100),
    operation_type ENUM('INSERT','UPDATE','DELETE','LOGIN','LOGOUT'),
    operation_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(50),
    description VARCHAR(255),
    FOREIGN KEY(user_id) REFERENCES mi_user(user_id)
);

USE motor_insurance_db;

-- ==========================================
-- 1. COUNTRY MASTER (20 Records)
-- ==========================================

INSERT INTO mi_country (country_name, country_code) VALUES
('India','IN'),
('United States','US'),
('United Kingdom','UK'),
('Canada','CA'),
('Australia','AU'),
('Germany','DE'),
('France','FR'),
('Japan','JP'),
('Singapore','SG'),
('Malaysia','MY'),
('United Arab Emirates','AE'),
('Saudi Arabia','SA'),
('South Africa','ZA'),
('Sri Lanka','LK'),
('Nepal','NP'),
('Bangladesh','BD'),
('Thailand','TH'),
('Indonesia','ID'),
('China','CN'),
('Brazil','BR');

-- ==========================================
-- 2. STATE MASTER (20 Records)
-- ==========================================

INSERT INTO mi_state (country_id,state_name) VALUES
(1,'Tamil Nadu'),
(1,'Kerala'),
(1,'Karnataka'),
(1,'Andhra Pradesh'),
(1,'Telangana'),
(1,'Maharashtra'),
(1,'Gujarat'),
(1,'Delhi'),
(1,'Rajasthan'),
(1,'Punjab'),
(1,'Odisha'),
(1,'West Bengal'),
(1,'Bihar'),
(1,'Uttar Pradesh'),
(1,'Madhya Pradesh'),
(1,'Assam'),
(1,'Goa'),
(1,'Haryana'),
(1,'Jharkhand'),
(1,'Chhattisgarh');

-- ==========================================
-- 3. CITY MASTER (20 Records)
-- ==========================================

INSERT INTO mi_city (state_id,city_name) VALUES
(1,'Chennai'),
(1,'Coimbatore'),
(1,'Madurai'),
(1,'Salem'),
(2,'Kochi'),
(2,'Thiruvananthapuram'),
(3,'Bengaluru'),
(3,'Mysuru'),
(4,'Vijayawada'),
(4,'Visakhapatnam'),
(5,'Hyderabad'),
(6,'Mumbai'),
(6,'Pune'),
(7,'Ahmedabad'),
(8,'New Delhi'),
(9,'Jaipur'),
(10,'Amritsar'),
(11,'Bhubaneswar'),
(12,'Kolkata'),
(13,'Patna');

-- ==========================================
-- 4. REGION MASTER (20 Records)
-- ==========================================

INSERT INTO mi_region (region_name) VALUES
('South'),
('North'),
('East'),
('West'),
('Central'),
('North East'),
('South Zone A'),
('South Zone B'),
('North Zone A'),
('North Zone B'),
('East Zone A'),
('East Zone B'),
('West Zone A'),
('West Zone B'),
('Metro'),
('Urban'),
('Semi Urban'),
('Rural'),
('International'),
('Corporate');

-- ==========================================
-- 5. VEHICLE MAKE MASTER (20 Records)
-- ==========================================

INSERT INTO mi_vehicle_make (make_name) VALUES
('Maruti Suzuki'),
('Hyundai'),
('Honda'),
('Toyota'),
('Tata'),
('Mahindra'),
('Kia'),
('MG'),
('Skoda'),
('Volkswagen'),
('Renault'),
('Nissan'),
('Ford'),
('BMW'),
('Mercedes-Benz'),
('Audi'),
('Jeep'),
('Volvo'),
('Ashok Leyland'),
('Eicher');

USE motor_insurance_db;

-- =====================================================
-- 6. VEHICLE MODEL MASTER (20 Records)
-- =====================================================

INSERT INTO mi_vehicle_model
(make_id, model_name, manufacture_year)
VALUES
(1,'Swift',2022),
(1,'Baleno',2023),
(2,'i20',2022),
(2,'Creta',2024),
(3,'City',2023),
(3,'Amaze',2022),
(4,'Innova Crysta',2024),
(4,'Fortuner',2023),
(5,'Nexon',2024),
(5,'Harrier',2023),
(6,'Scorpio N',2024),
(6,'XUV700',2024),
(7,'Seltos',2023),
(7,'Sonet',2024),
(8,'Hector',2023),
(9,'Slavia',2024),
(10,'Virtus',2023),
(11,'Kiger',2023),
(12,'Magnite',2024),
(13,'EcoSport',2022);

-- =====================================================
-- 7. VEHICLE COLOR MASTER (20 Records)
-- =====================================================

INSERT INTO mi_vehicle_color
(color_name)
VALUES
('White'),
('Black'),
('Silver'),
('Grey'),
('Blue'),
('Red'),
('Yellow'),
('Green'),
('Orange'),
('Brown'),
('Golden'),
('Purple'),
('Maroon'),
('Pearl White'),
('Metallic Grey'),
('Sky Blue'),
('Wine Red'),
('Champagne'),
('Dark Green'),
('Matte Black');

-- =====================================================
-- 8. VEHICLE BODY MASTER (20 Records)
-- =====================================================

INSERT INTO mi_vehicle_body
(body_type)
VALUES
('Sedan'),
('SUV'),
('Hatchback'),
('Coupe'),
('Convertible'),
('Pickup'),
('Van'),
('Mini Van'),
('Truck'),
('Bus'),
('Jeep'),
('Wagon'),
('Luxury Sedan'),
('Sports Car'),
('Electric SUV'),
('Compact SUV'),
('Micro Car'),
('Taxi'),
('Ambulance'),
('Trailer');

-- =====================================================
-- 9. VEHICLE CATEGORY MASTER (20 Records)
-- =====================================================

INSERT INTO mi_vehicle_category
(category_name)
VALUES
('Private'),
('Commercial'),
('Taxi'),
('School Bus'),
('Government'),
('Police'),
('Ambulance'),
('Rental'),
('Luxury'),
('Sports'),
('Electric'),
('Hybrid'),
('Motorcycle'),
('Goods Carrier'),
('Passenger Carrier'),
('Agricultural'),
('Construction'),
('Delivery Vehicle'),
('Tourist'),
('Corporate');

-- =====================================================
-- 10. PRODUCT MASTER (20 Records)
-- =====================================================

INSERT INTO mi_product
(product_name,
coverage_type,
base_premium,
gst_percent)
VALUES
('Basic Third Party','TPL',3000,18),
('Comprehensive Silver','Comprehensive',7500,18),
('Comprehensive Gold','Comprehensive',9500,18),
('Comprehensive Platinum','Comprehensive',12000,18),
('Zero Depreciation','Addon',4500,18),
('Engine Protect','Addon',2500,18),
('Roadside Assistance','Addon',1500,18),
('Return To Invoice','Addon',2800,18),
('NCB Protect','Addon',2200,18),
('Passenger Cover','Addon',900,18),
('Owner Driver Cover','Addon',750,18),
('Key Replacement','Addon',600,18),
('Tyre Protection','Addon',1800,18),
('Consumables Cover','Addon',1400,18),
('Invoice Protect','Addon',2600,18),
('Commercial Package','Commercial',15000,18),
('Taxi Package','Commercial',13500,18),
('Electric Vehicle Cover','Comprehensive',8500,18),
('Premium Bike Cover','Motorcycle',4200,18),
('Fleet Insurance','Commercial',25000,18);

USE motor_insurance_db;

-- =====================================================
-- 11. USER MASTER (20 Records)
-- =====================================================

INSERT INTO mi_user
(first_name,last_name,gender,dob,email,phone,mobile,address,
city_id,state_id,country_id,national_id,nationality,user_role)
VALUES
('Arun','Kumar','Male','1992-05-12','arun@gmail.com','0442233441','9876500001','Chennai',1,1,1,'100000001','Indian','ADMIN'),
('Priya','Sharma','Female','1994-02-18','priya@gmail.com','0442233442','9876500002','Coimbatore',2,1,1,'100000002','Indian','UNDERWRITER'),
('Rahul','Verma','Male','1990-07-20','rahul@gmail.com','0442233443','9876500003','Madurai',3,1,1,'100000003','Indian','BROKER'),
('Anitha','R','Female','1995-01-15','anitha@gmail.com','0442233444','9876500004','Salem',4,1,1,'100000004','Indian','BROKER'),
('Vijay','K','Male','1989-10-10','vijay@gmail.com','0442233445','9876500005','Kochi',5,2,1,'100000005','Indian','AGENT'),
('Sneha','S','Female','1993-03-17','sneha@gmail.com','0442233446','9876500006','Trivandrum',6,2,1,'100000006','Indian','AGENT'),
('Kiran','Rao','Male','1991-09-19','kiran@gmail.com','0442233447','9876500007','Bengaluru',7,3,1,'100000007','Indian','BROKER'),
('Deepa','Nair','Female','1992-08-14','deepa@gmail.com','0442233448','9876500008','Mysuru',8,3,1,'100000008','Indian','UNDERWRITER'),
('Ajith','M','Male','1994-11-02','ajith@gmail.com','0442233449','9876500009','Vijayawada',9,4,1,'100000009','Indian','AGENT'),
('Manoj','Das','Male','1990-06-21','manoj@gmail.com','0442233450','9876500010','Vizag',10,4,1,'100000010','Indian','OPERATION'),
('Ramesh','Patel','Male','1991-01-11','ramesh@gmail.com','0442233451','9876500011','Hyderabad',11,5,1,'100000011','Indian','BROKER'),
('Pooja','Mehta','Female','1995-04-28','pooja@gmail.com','0442233452','9876500012','Mumbai',12,6,1,'100000012','Indian','AGENT'),
('Suresh','Yadav','Male','1988-12-18','suresh@gmail.com','0442233453','9876500013','Pune',13,6,1,'100000013','Indian','BROKER'),
('Kavya','R','Female','1996-09-09','kavya@gmail.com','0442233454','9876500014','Ahmedabad',14,7,1,'100000014','Indian','ADMIN'),
('Harish','G','Male','1990-02-22','harish@gmail.com','0442233455','9876500015','Delhi',15,8,1,'100000015','Indian','UNDERWRITER'),
('Asha','P','Female','1997-07-17','asha@gmail.com','0442233456','9876500016','Jaipur',16,9,1,'100000016','Indian','AGENT'),
('Naveen','B','Male','1993-08-13','naveen@gmail.com','0442233457','9876500017','Amritsar',17,10,1,'100000017','Indian','BROKER'),
('Divya','L','Female','1992-11-25','divya@gmail.com','0442233458','9876500018','Bhubaneswar',18,11,1,'100000018','Indian','OPERATION'),
('Ravi','Singh','Male','1991-05-07','ravi@gmail.com','0442233459','9876500019','Kolkata',19,12,1,'100000019','Indian','BROKER'),
('Keerthi','M','Female','1998-01-29','keerthi@gmail.com','0442233460','9876500020','Patna',20,13,1,'100000020','Indian','AGENT');

-- =====================================================
-- 12. LOGIN TABLE (20 Records)
-- =====================================================

INSERT INTO mi_login
(user_id,username,password_hash,last_login,login_status)
VALUES
(1,'admin1','hash001',NOW(),'ACTIVE'),
(2,'uw1','hash002',NOW(),'ACTIVE'),
(3,'broker1','hash003',NOW(),'ACTIVE'),
(4,'broker2','hash004',NOW(),'ACTIVE'),
(5,'agent1','hash005',NOW(),'ACTIVE'),
(6,'agent2','hash006',NOW(),'ACTIVE'),
(7,'broker3','hash007',NOW(),'ACTIVE'),
(8,'uw2','hash008',NOW(),'ACTIVE'),
(9,'agent3','hash009',NOW(),'ACTIVE'),
(10,'ops1','hash010',NOW(),'ACTIVE'),
(11,'broker4','hash011',NOW(),'ACTIVE'),
(12,'agent4','hash012',NOW(),'ACTIVE'),
(13,'broker5','hash013',NOW(),'ACTIVE'),
(14,'admin2','hash014',NOW(),'ACTIVE'),
(15,'uw3','hash015',NOW(),'ACTIVE'),
(16,'agent5','hash016',NOW(),'ACTIVE'),
(17,'broker6','hash017',NOW(),'ACTIVE'),
(18,'ops2','hash018',NOW(),'ACTIVE'),
(19,'broker7','hash019',NOW(),'ACTIVE'),
(20,'agent6','hash020',NOW(),'ACTIVE');

-- =====================================================
-- 13. BROKER TABLE (7 Records)
-- =====================================================

INSERT INTO mi_broker
(user_id,broker_name,organization_name,license_number,
commission_rate,prepaid_balance)
VALUES
(3,'Rahul Verma','RV Insurance','LIC1001',10.50,500000),
(4,'Anitha R','AR Brokers','LIC1002',11.00,300000),
(7,'Kiran Rao','KR Insurance','LIC1003',9.50,650000),
(11,'Ramesh Patel','RP Insurance','LIC1004',10.00,450000),
(13,'Suresh Yadav','SY Brokers','LIC1005',12.00,350000),
(17,'Naveen B','NB Insurance','LIC1006',10.75,250000),
(19,'Ravi Singh','RS Insurance','LIC1007',11.25,400000);

-- =====================================================
-- 14. CUSTOMER TABLE (20 Records)
-- =====================================================

INSERT INTO mi_customer
(first_name,last_name,gender,dob,email,mobile,address,
city_id,state_id,country_id,national_id,occupation)
VALUES
('Amit','Shah','Male','1991-01-10','amit1@gmail.com','9000000001','Chennai',1,1,1,'C1001','Engineer'),
('Neha','Kapoor','Female','1994-04-15','neha@gmail.com','9000000002','Coimbatore',2,1,1,'C1002','Teacher'),
('Sanjay','Rao','Male','1989-03-20','sanjay@gmail.com','9000000003','Madurai',3,1,1,'C1003','Doctor'),
('Lakshmi','S','Female','1993-05-22','lakshmi@gmail.com','9000000004','Salem',4,1,1,'C1004','Lawyer'),
('Arvind','K','Male','1990-08-08','arvind@gmail.com','9000000005','Kochi',5,2,1,'C1005','Business'),
('Customer6','A','Male','1992-02-02','c6@gmail.com','9000000006','City',6,2,1,'C1006','Engineer'),
('Customer7','A','Male','1992-02-02','c7@gmail.com','9000000007','City',7,3,1,'C1007','Engineer'),
('Customer8','A','Male','1992-02-02','c8@gmail.com','9000000008','City',8,3,1,'C1008','Engineer'),
('Customer9','A','Male','1992-02-02','c9@gmail.com','9000000009','City',9,4,1,'C1009','Engineer'),
('Customer10','A','Male','1992-02-02','c10@gmail.com','9000000010','City',10,4,1,'C1010','Engineer'),
('Customer11','A','Male','1992-02-02','c11@gmail.com','9000000011','City',11,5,1,'C1011','Engineer'),
('Customer12','A','Male','1992-02-02','c12@gmail.com','9000000012','City',12,6,1,'C1012','Engineer'),
('Customer13','A','Male','1992-02-02','c13@gmail.com','9000000013','City',13,6,1,'C1013','Engineer'),
('Customer14','A','Male','1992-02-02','c14@gmail.com','9000000014','City',14,7,1,'C1014','Engineer'),
('Customer15','A','Male','1992-02-02','c15@gmail.com','9000000015','City',15,8,1,'C1015','Engineer'),
('Customer16','A','Male','1992-02-02','c16@gmail.com','9000000016','City',16,9,1,'C1016','Engineer'),
('Customer17','A','Male','1992-02-02','c17@gmail.com','9000000017','City',17,10,1,'C1017','Engineer'),
('Customer18','A','Male','1992-02-02','c18@gmail.com','9000000018','City',18,11,1,'C1018','Engineer'),
('Customer19','A','Male','1992-02-02','c19@gmail.com','9000000019','City',19,12,1,'C1019','Engineer'),
('Customer20','A','Male','1992-02-02','c20@gmail.com','9000000020','City',20,13,1,'C1020','Engineer');

-- =====================================================
-- 15. VEHICLE TABLE (20 Records)
-- =====================================================

INSERT INTO mi_vehicle
(customer_id,make_id,model_id,color_id,body_id,category_id,
registration_no,engine_no,chassis_no,manufacture_year,
purchase_date,vehicle_value)
VALUES
(1,1,1,1,3,1,'TN01AA1001','ENG1001','CH1001',2022,'2022-01-15',650000),
(2,2,3,2,2,1,'TN02AA1002','ENG1002','CH1002',2023,'2023-02-12',950000),
(3,3,5,3,1,1,'TN03AA1003','ENG1003','CH1003',2022,'2022-03-20',1200000),
(4,4,7,4,2,1,'TN04AA1004','ENG1004','CH1004',2024,'2024-01-05',2200000),
(5,5,9,5,16,1,'KL01AA1005','ENG1005','CH1005',2024,'2024-02-18',1450000),
(6,6,11,6,2,2,'KL02AA1006','ENG1006','CH1006',2024,'2024-02-25',1800000),
(7,7,13,7,2,1,'KA01AA1007','ENG1007','CH1007',2023,'2023-08-01',1350000),
(8,8,15,8,2,1,'KA02AA1008','ENG1008','CH1008',2023,'2023-09-10',1700000),
(9,9,16,9,1,9,'AP01AA1009','ENG1009','CH1009',2024,'2024-03-15',1600000),
(10,10,17,10,1,1,'AP02AA1010','ENG1010','CH1010',2023,'2023-07-20',1550000),
(11,11,18,11,3,1,'TS01AA1011','ENG1011','CH1011',2023,'2023-06-11',850000),
(12,12,19,12,16,1,'MH01AA1012','ENG1012','CH1012',2024,'2024-01-30',900000),
(13,13,20,13,2,2,'MH02AA1013','ENG1013','CH1013',2022,'2022-12-10',780000),
(14,14,1,14,13,9,'GJ01AA1014','ENG1014','CH1014',2024,'2024-04-01',6200000),
(15,15,2,15,13,9,'DL01AA1015','ENG1015','CH1015',2024,'2024-05-01',7200000),
(16,16,3,16,14,10,'RJ01AA1016','ENG1016','CH1016',2023,'2023-10-01',5500000),
(17,17,4,17,11,2,'PB01AA1017','ENG1017','CH1017',2024,'2024-03-01',3100000),
(18,18,5,18,2,15,'OD01AA1018','ENG1018','CH1018',2023,'2023-08-15',4200000),
(19,19,6,19,9,14,'WB01AA1019','ENG1019','CH1019',2022,'2022-06-01',2800000),
(20,20,7,20,9,14,'BR01AA1020','ENG1020','CH1020',2023,'2023-05-10',2600000);

USE motor_insurance_db;

-- =====================================================
-- 16. QUOTE TABLE (20 Records)
-- =====================================================

INSERT INTO mi_quote
(customer_id,vehicle_id,broker_id,product_id,quote_date,
coverage_type,basic_premium,addon_amount,tax_amount,
total_premium,quote_status)
VALUES
(1,1,1,2,'2025-01-01','Comprehensive',7500,1200,1566,10266,'APPROVED'),
(2,2,2,3,'2025-01-02','Comprehensive',9500,1500,1980,12980,'APPROVED'),
(3,3,3,4,'2025-01-03','Comprehensive',12000,1800,2484,16284,'APPROVED'),
(4,4,4,5,'2025-01-04','Zero Dep',4500,700,936,6136,'NEW'),
(5,5,5,6,'2025-01-05','Engine Protect',2500,500,540,3540,'APPROVED'),
(6,6,6,7,'2025-01-06','RSA',1500,300,324,2124,'NEW'),
(7,7,7,8,'2025-01-07','Invoice',2800,400,576,3776,'APPROVED'),
(8,8,1,9,'2025-01-08','NCB',2200,250,441,2891,'NEW'),
(9,9,2,10,'2025-01-09','Passenger',900,200,198,1298,'APPROVED'),
(10,10,3,11,'2025-01-10','Owner',750,150,162,1062,'APPROVED'),
(11,11,4,12,'2025-01-11','Key',600,100,126,826,'NEW'),
(12,12,5,13,'2025-01-12','Tyre',1800,250,369,2419,'APPROVED'),
(13,13,6,14,'2025-01-13','Consumables',1400,200,288,1888,'NEW'),
(14,14,7,15,'2025-01-14','Invoice',2600,350,531,3481,'APPROVED'),
(15,15,1,16,'2025-01-15','Commercial',15000,2500,3150,20650,'APPROVED'),
(16,16,2,17,'2025-01-16','Taxi',13500,2200,2826,18526,'NEW'),
(17,17,3,18,'2025-01-17','EV',8500,900,1692,11092,'APPROVED'),
(18,18,4,19,'2025-01-18','Bike',4200,600,864,5664,'NEW'),
(19,19,5,20,'2025-01-19','Fleet',25000,5000,5400,35400,'APPROVED'),
(20,20,6,2,'2025-01-20','Comprehensive',7500,1000,1530,10030,'NEW');

-- =====================================================
-- 17. PREMIUM CONFIGURATION (20 Records)
-- =====================================================

INSERT INTO mi_premium_config
(category_id,product_id,min_vehicle_value,
max_vehicle_value,premium_percentage,
gst_percentage,effective_from,effective_to,status)
VALUES
(1,2,0,500000,1.50,18,'2025-01-01','2025-12-31','ACTIVE'),
(2,3,500001,1000000,1.80,18,'2025-01-01','2025-12-31','ACTIVE'),
(3,4,1000001,1500000,2.00,18,'2025-01-01','2025-12-31','ACTIVE'),
(4,5,1500001,2000000,2.20,18,'2025-01-01','2025-12-31','ACTIVE'),
(5,6,2000001,2500000,2.40,18,'2025-01-01','2025-12-31','ACTIVE'),
(6,7,2500001,3000000,2.60,18,'2025-01-01','2025-12-31','ACTIVE'),
(7,8,3000001,3500000,2.80,18,'2025-01-01','2025-12-31','ACTIVE'),
(8,9,3500001,4000000,3.00,18,'2025-01-01','2025-12-31','ACTIVE'),
(9,10,4000001,4500000,3.20,18,'2025-01-01','2025-12-31','ACTIVE'),
(10,11,4500001,5000000,3.40,18,'2025-01-01','2025-12-31','ACTIVE'),
(11,12,5000001,5500000,3.60,18,'2025-01-01','2025-12-31','ACTIVE'),
(12,13,5500001,6000000,3.80,18,'2025-01-01','2025-12-31','ACTIVE'),
(13,14,6000001,6500000,4.00,18,'2025-01-01','2025-12-31','ACTIVE'),
(14,15,6500001,7000000,4.20,18,'2025-01-01','2025-12-31','ACTIVE'),
(15,16,7000001,7500000,4.40,18,'2025-01-01','2025-12-31','ACTIVE'),
(16,17,7500001,8000000,4.60,18,'2025-01-01','2025-12-31','ACTIVE'),
(17,18,8000001,8500000,4.80,18,'2025-01-01','2025-12-31','ACTIVE'),
(18,19,8500001,9000000,5.00,18,'2025-01-01','2025-12-31','ACTIVE'),
(19,20,9000001,9500000,5.20,18,'2025-01-01','2025-12-31','ACTIVE'),
(20,2,9500001,10000000,5.50,18,'2025-01-01','2025-12-31','ACTIVE');

-- =====================================================
-- 18. PREMIUM TABLE (20 Records)
-- =====================================================

INSERT INTO mi_premium
(quote_id,base_premium,addon_premium,
gst_amount,discount_amount,final_premium)
VALUES
(1,7500,1200,1566,0,10266),
(2,9500,1500,1980,500,12480),
(3,12000,1800,2484,0,16284),
(4,4500,700,936,100,6036),
(5,2500,500,540,0,3540),
(6,1500,300,324,0,2124),
(7,2800,400,576,50,3726),
(8,2200,250,441,0,2891),
(9,900,200,198,0,1298),
(10,750,150,162,0,1062),
(11,600,100,126,0,826),
(12,1800,250,369,0,2419),
(13,1400,200,288,0,1888),
(14,2600,350,531,0,3481),
(15,15000,2500,3150,500,20150),
(16,13500,2200,2826,0,18526),
(17,8500,900,1692,0,11092),
(18,4200,600,864,100,5564),
(19,25000,5000,5400,1000,34400),
(20,7500,1000,1530,0,10030);

-- =====================================================
-- 19. POLICY TABLE (20 Records)
-- =====================================================

INSERT INTO mi_policy
(policy_number,quote_id,issue_date,start_date,
expiry_date,policy_status)
VALUES
('POL10001',1,'2025-01-01','2025-01-01','2025-12-31','ACTIVE'),
('POL10002',2,'2025-01-02','2025-01-02','2026-01-01','ACTIVE'),
('POL10003',3,'2025-01-03','2025-01-03','2026-01-02','ACTIVE'),
('POL10004',4,'2025-01-04','2025-01-04','2026-01-03','ACTIVE'),
('POL10005',5,'2025-01-05','2025-01-05','2026-01-04','ACTIVE'),
('POL10006',6,'2025-01-06','2025-01-06','2026-01-05','ACTIVE'),
('POL10007',7,'2025-01-07','2025-01-07','2026-01-06','ACTIVE'),
('POL10008',8,'2025-01-08','2025-01-08','2026-01-07','ACTIVE'),
('POL10009',9,'2025-01-09','2025-01-09','2026-01-08','ACTIVE'),
('POL10010',10,'2025-01-10','2025-01-10','2026-01-09','ACTIVE'),
('POL10011',11,'2025-01-11','2025-01-11','2026-01-10','ACTIVE'),
('POL10012',12,'2025-01-12','2025-01-12','2026-01-11','ACTIVE'),
('POL10013',13,'2025-01-13','2025-01-13','2026-01-12','ACTIVE'),
('POL10014',14,'2025-01-14','2025-01-14','2026-01-13','ACTIVE'),
('POL10015',15,'2025-01-15','2025-01-15','2026-01-14','ACTIVE'),
('POL10016',16,'2025-01-16','2025-01-16','2026-01-15','ACTIVE'),
('POL10017',17,'2025-01-17','2025-01-17','2026-01-16','ACTIVE'),
('POL10018',18,'2025-01-18','2025-01-18','2026-01-17','ACTIVE'),
('POL10019',19,'2025-01-19','2025-01-19','2026-01-18','ACTIVE'),
('POL10020',20,'2025-01-20','2025-01-20','2026-01-19','ACTIVE');

-- =====================================================
-- 20. PAYMENT TABLE (20 Records)
-- =====================================================

INSERT INTO mi_payment
(policy_id,payment_date,payment_method,
currency,amount,payment_status,transaction_reference)
VALUES
(1,NOW(),'UPI','INR',10266,'SUCCESS','TXN10001'),
(2,NOW(),'CARD','INR',12480,'SUCCESS','TXN10002'),
(3,NOW(),'NETBANKING','INR',16284,'SUCCESS','TXN10003'),
(4,NOW(),'CARD','INR',6036,'SUCCESS','TXN10004'),
(5,NOW(),'UPI','INR',3540,'SUCCESS','TXN10005'),
(6,NOW(),'CASH','INR',2124,'SUCCESS','TXN10006'),
(7,NOW(),'CARD','USD',3726,'SUCCESS','TXN10007'),
(8,NOW(),'UPI','INR',2891,'SUCCESS','TXN10008'),
(9,NOW(),'NETBANKING','INR',1298,'SUCCESS','TXN10009'),
(10,NOW(),'CARD','INR',1062,'SUCCESS','TXN10010'),
(11,NOW(),'UPI','INR',826,'SUCCESS','TXN10011'),
(12,NOW(),'CARD','INR',2419,'SUCCESS','TXN10012'),
(13,NOW(),'NETBANKING','INR',1888,'SUCCESS','TXN10013'),
(14,NOW(),'UPI','INR',3481,'SUCCESS','TXN10014'),
(15,NOW(),'CARD','USD',20150,'SUCCESS','TXN10015'),
(16,NOW(),'NETBANKING','INR',18526,'SUCCESS','TXN10016'),
(17,NOW(),'UPI','INR',11092,'SUCCESS','TXN10017'),
(18,NOW(),'CARD','INR',5564,'SUCCESS','TXN10018'),
(19,NOW(),'NETBANKING','USD',34400,'SUCCESS','TXN10019'),
(20,NOW(),'UPI','INR',10030,'SUCCESS','TXN10020');

USE motor_insurance_db;

-- =====================================================
-- 21. CLAIM TABLE (20 Records)
-- =====================================================

INSERT INTO mi_claim
(policy_id,claim_date,accident_date,claim_amount,
approved_amount,claim_status,remarks)
VALUES
(1,'2025-03-10','2025-03-08',25000,24000,'APPROVED','Minor bumper damage'),
(2,'2025-03-15','2025-03-12',18000,18000,'APPROVED','Windshield replacement'),
(3,'2025-04-01','2025-03-30',45000,42000,'APPROVED','Front collision'),
(4,'2025-04-05','2025-04-02',12000,NULL,'PENDING','Inspection pending'),
(5,'2025-04-08','2025-04-05',35000,34000,'APPROVED','Door replacement'),
(6,'2025-04-12','2025-04-10',8000,NULL,'REJECTED','Policy expired'),
(7,'2025-04-18','2025-04-15',28000,NULL,'HOLD','Need documents'),
(8,'2025-04-20','2025-04-17',17000,16500,'APPROVED','Glass damage'),
(9,'2025-04-22','2025-04-20',9500,NULL,'PENDING','Survey pending'),
(10,'2025-04-25','2025-04-21',21000,20500,'APPROVED','Rear accident'),
(11,'2025-05-01','2025-04-29',14000,13500,'APPROVED','Tyre damage'),
(12,'2025-05-04','2025-05-01',16000,NULL,'HOLD','Verification'),
(13,'2025-05-07','2025-05-05',27000,26000,'APPROVED','Flood damage'),
(14,'2025-05-10','2025-05-08',19000,18500,'APPROVED','Engine repair'),
(15,'2025-05-15','2025-05-12',85000,83000,'APPROVED','Major accident'),
(16,'2025-05-18','2025-05-16',11000,NULL,'PENDING','Awaiting approval'),
(17,'2025-05-20','2025-05-18',32000,31000,'APPROVED','Body repair'),
(18,'2025-05-23','2025-05-20',9000,NULL,'REJECTED','Invalid documents'),
(19,'2025-05-26','2025-05-24',125000,120000,'APPROVED','Fleet accident'),
(20,'2025-05-30','2025-05-28',15000,NULL,'PENDING','Survey not completed');

-- =====================================================
-- 22. ENDORSEMENT TABLE (20 Records)
-- =====================================================

INSERT INTO mi_endorsement
(policy_id,endorsement_date,endorsement_type,
old_value,new_value,remarks)
VALUES
(1,'2025-02-01','Address Change','Old Address','New Address','Updated'),
(2,'2025-02-02','Mobile Number','9876500001','9876501001','Updated'),
(3,'2025-02-03','Nominee','Father','Spouse','Updated'),
(4,'2025-02-04','Engine Number','ENG1004','ENG9004','Corrected'),
(5,'2025-02-05','Vehicle Color','White','Black','Updated'),
(6,'2025-02-06','Registration','KL01AA1006','KL01AB1006','Corrected'),
(7,'2025-02-07','Address','Old','New','Updated'),
(8,'2025-02-08','Email','old@mail.com','new@mail.com','Updated'),
(9,'2025-02-09','Phone','111111','222222','Updated'),
(10,'2025-02-10','Coverage','Basic','Premium','Upgraded'),
(11,'2025-02-11','Driver','Driver1','Driver2','Changed'),
(12,'2025-02-12','Fuel Type','Diesel','Petrol','Updated'),
(13,'2025-02-13','Color','Blue','Grey','Updated'),
(14,'2025-02-14','Address','Old','New','Updated'),
(15,'2025-02-15','Nominee','Mother','Brother','Updated'),
(16,'2025-02-16','Contact','Old','New','Updated'),
(17,'2025-02-17','Vehicle Value','3000000','3200000','Updated'),
(18,'2025-02-18','Coverage','Silver','Gold','Upgraded'),
(19,'2025-02-19','Broker','Broker A','Broker B','Transferred'),
(20,'2025-02-20','Policy Term','1 Year','2 Years','Extended');

-- =====================================================
-- 23. RENEWAL TABLE (20 Records)
-- =====================================================

INSERT INTO mi_renewal
(policy_id,renewal_date,renewed_until,
renewal_premium,renewal_status)
VALUES
(1,'2025-12-20','2026-12-31',10500,'COMPLETED'),
(2,'2025-12-21','2027-01-01',12600,'COMPLETED'),
(3,'2025-12-22','2027-01-02',16500,'COMPLETED'),
(4,'2025-12-23','2027-01-03',6200,'PENDING'),
(5,'2025-12-24','2027-01-04',3700,'COMPLETED'),
(6,'2025-12-25','2027-01-05',2200,'FAILED'),
(7,'2025-12-26','2027-01-06',3900,'COMPLETED'),
(8,'2025-12-27','2027-01-07',3000,'PENDING'),
(9,'2025-12-28','2027-01-08',1400,'COMPLETED'),
(10,'2025-12-29','2027-01-09',1200,'COMPLETED'),
(11,'2025-12-30','2027-01-10',900,'COMPLETED'),
(12,'2025-12-31','2027-01-11',2500,'PENDING'),
(13,'2026-01-01','2027-01-12',1900,'COMPLETED'),
(14,'2026-01-02','2027-01-13',3600,'COMPLETED'),
(15,'2026-01-03','2027-01-14',20500,'COMPLETED'),
(16,'2026-01-04','2027-01-15',18600,'FAILED'),
(17,'2026-01-05','2027-01-16',11200,'COMPLETED'),
(18,'2026-01-06','2027-01-17',5700,'PENDING'),
(19,'2026-01-07','2027-01-18',35000,'COMPLETED'),
(20,'2026-01-08','2027-01-19',10200,'COMPLETED');

-- =====================================================
-- 24. FINANCIAL NOTE TABLE (20 Records)
-- =====================================================

INSERT INTO mi_financial_note
(policy_id,note_type,note_number,note_date,
amount,remarks)
VALUES
(1,'CREDIT','CN1001','2025-01-10',500,'Discount'),
(2,'DEBIT','DN1002','2025-01-11',350,'Extra Cover'),
(3,'CREDIT','CN1003','2025-01-12',1000,'Loyalty Bonus'),
(4,'DEBIT','DN1004','2025-01-13',250,'Policy Change'),
(5,'CREDIT','CN1005','2025-01-14',450,'Refund'),
(6,'DEBIT','DN1006','2025-01-15',150,'Processing Fee'),
(7,'CREDIT','CN1007','2025-01-16',800,'Adjustment'),
(8,'DEBIT','DN1008','2025-01-17',200,'Additional GST'),
(9,'CREDIT','CN1009','2025-01-18',350,'Cashback'),
(10,'DEBIT','DN1010','2025-01-19',275,'Correction'),
(11,'CREDIT','CN1011','2025-01-20',150,'Offer'),
(12,'DEBIT','DN1012','2025-01-21',180,'Admin Charge'),
(13,'CREDIT','CN1013','2025-01-22',500,'Refund'),
(14,'DEBIT','DN1014','2025-01-23',400,'Policy Upgrade'),
(15,'CREDIT','CN1015','2025-01-24',1200,'Special Discount'),
(16,'DEBIT','DN1016','2025-01-25',600,'Extra Premium'),
(17,'CREDIT','CN1017','2025-01-26',700,'Bonus'),
(18,'DEBIT','DN1018','2025-01-27',320,'Fee'),
(19,'CREDIT','CN1019','2025-01-28',2000,'Fleet Discount'),
(20,'DEBIT','DN1020','2025-01-29',500,'Correction');

-- =====================================================
-- 25. AUDIT LOG TABLE (20 Records)
-- =====================================================

INSERT INTO mi_audit_log
(user_id,table_name,operation_type,
operation_time,ip_address,description)
VALUES
(1,'mi_user','INSERT',NOW(),'192.168.1.1','Admin created user'),
(2,'mi_quote','UPDATE',NOW(),'192.168.1.2','Quote approved'),
(3,'mi_policy','INSERT',NOW(),'192.168.1.3','Policy issued'),
(4,'mi_payment','INSERT',NOW(),'192.168.1.4','Payment received'),
(5,'mi_claim','UPDATE',NOW(),'192.168.1.5','Claim submitted'),
(6,'mi_vehicle','UPDATE',NOW(),'192.168.1.6','Vehicle updated'),
(7,'mi_customer','INSERT',NOW(),'192.168.1.7','Customer added'),
(8,'mi_login','LOGIN',NOW(),'192.168.1.8','User login'),
(9,'mi_quote','DELETE',NOW(),'192.168.1.9','Quote removed'),
(10,'mi_policy','UPDATE',NOW(),'192.168.1.10','Policy renewed'),
(11,'mi_claim','UPDATE',NOW(),'192.168.1.11','Claim approved'),
(12,'mi_payment','UPDATE',NOW(),'192.168.1.12','Payment verified'),
(13,'mi_endorsement','INSERT',NOW(),'192.168.1.13','Endorsement added'),
(14,'mi_renewal','UPDATE',NOW(),'192.168.1.14','Renewal completed'),
(15,'mi_financial_note','INSERT',NOW(),'192.168.1.15','Credit note created'),
(16,'mi_login','LOGOUT',NOW(),'192.168.1.16','User logout'),
(17,'mi_customer','UPDATE',NOW(),'192.168.1.17','Customer updated'),
(18,'mi_vehicle','INSERT',NOW(),'192.168.1.18','Vehicle registered'),
(19,'mi_quote','UPDATE',NOW(),'192.168.1.19','Premium recalculated'),
(20,'mi_policy','UPDATE',NOW(),'192.168.1.20','Policy cancelled');

USE motor_insurance_db;

--- Query 1 – SELECT, WHERE, ORDER BY, LIMIT
SELECT customer_id,
       first_name,
       last_name,
       mobile
FROM mi_customer
WHERE state_id = 1
ORDER BY first_name ASC
LIMIT 5;

--- Query 2 – UPDATE (DML)
UPDATE mi_customer
SET occupation = 'Software Engineer',
    mobile = '9999999999'
WHERE customer_id = 5;

SELECT * FROM mi_customer
WHERE customer_id = 5;

--- Query 3 – DELETE (DML)
DELETE FROM mi_claim
WHERE claim_status = 'REJECTED'
AND claim_amount < 10000;

SELECT * FROM mi_claim;

--- Query 4 – Aggregate Functions + GROUP BY + HAVING
SELECT broker_id,
       COUNT(*) AS TotalQuotes,
       SUM(total_premium) AS TotalPremium
FROM mi_quote
GROUP BY broker_id
HAVING SUM(total_premium) > 15000;

--- Query 5 – INNER JOIN
SELECT c.first_name,
       v.registration_no,
       p.policy_number
FROM mi_customer c
INNER JOIN mi_vehicle v
ON c.customer_id = v.customer_id
INNER JOIN mi_policy p
ON v.vehicle_id = p.quote_id;

--- Query 6 – LEFT JOIN
SELECT c.first_name,
       q.quote_id,
       q.total_premium
FROM mi_customer c
LEFT JOIN mi_quote q
ON c.customer_id = q.customer_id;

-- Query 7 – RIGHT JOIN
SELECT b.broker_name,
       q.quote_id,
       q.total_premium
FROM mi_broker b
RIGHT JOIN mi_quote q
ON b.broker_id = q.broker_id;

-- Query 8 – CASE + BETWEEN
SELECT quote_id,
       total_premium,
CASE
WHEN total_premium BETWEEN 0 AND 5000 THEN 'Low'
WHEN total_premium BETWEEN 5001 AND 15000 THEN 'Medium'
ELSE 'High'
END AS PremiumLevel
FROM mi_quote;

-- Query 9 – LIKE + IN + DISTINCT
SELECT DISTINCT city_id,
       first_name,
       occupation
FROM mi_customer
WHERE occupation IN ('Engineer','Doctor')
AND first_name LIKE 'A%';

-- Query 10 – Subquery
SELECT first_name,
       last_name
FROM mi_customer
WHERE customer_id IN
(
SELECT customer_id
FROM mi_quote
WHERE total_premium > 10000
);

-- Query 11 – View
CREATE VIEW vw_policy_details AS
SELECT p.policy_number,
       c.first_name,
       q.total_premium
FROM mi_policy p
JOIN mi_quote q
ON p.quote_id=q.quote_id
JOIN mi_customer c
ON q.customer_id=c.customer_id;

---Query 12 – Stored Procedure
DELIMITER $$

CREATE PROCEDURE GetCustomerPolicy()
BEGIN
SELECT first_name,last_name
FROM mi_customer;
END$$

DELIMITER ;

---Query 13 – Trigger
DELIMITER $$

CREATE TRIGGER trg_before_payment
BEFORE INSERT
ON mi_payment
FOR EACH ROW
SET NEW.currency='INR';

$$
DELIMITER ;

-- Query 14 – Transaction + COMMIT + ROLLBACK
START TRANSACTION;

UPDATE mi_payment
SET amount = amount + 500
WHERE payment_id = 1;

COMMIT;



-- Query 15 – CTE + Window Function + Index + DCL
CREATE INDEX idx_customer
ON mi_customer(first_name);

WITH PremiumCTE AS
(
SELECT customer_id,total_premium,
ROW_NUMBER() OVER(ORDER BY total_premium DESC) AS RankNo
FROM mi_quote
)
SELECT * FROM PremiumCTE;

GRANT SELECT
ON motor_insurance_db.*
TO 'student'@'localhost';

-- ==========================================================
-- Scenario 1 : Register a New Customer
-- Business Requirement:
-- A new customer purchases motor insurance.
-- ==========================================================

INSERT INTO mi_customer
(
first_name,
last_name,
gender,
dob,
email,
mobile,
address,
city_id,
state_id,
country_id,
national_id,
occupation
)

VALUES
(
'Rohit',
'Sharma',
'Male',
'1995-06-15',
'rohit@gmail.com',
'9876543210',
'Anna Nagar',
1,
1,
1,
'C1021',
'Software Engineer'
);

SELECT *
FROM mi_customer
WHERE email='rohit@gmail.com';

-- ==========================================================
-- Scenario 2 : Register a New Vehicle
-- ==========================================================

INSERT INTO mi_vehicle
(
customer_id,
make_id,
model_id,
color_id,
body_id,
category_id,
registration_no,
engine_no,
chassis_no,
manufacture_year,
purchase_date,
vehicle_value
)

VALUES
(
21,
2,
3,
2,
2,
1,
'TN10AB2026',
'ENG2026',
'CH2026',
2025,
'2025-12-01',
1250000
);

SELECT
registration_no,
vehicle_value
FROM mi_vehicle
WHERE customer_id=21;

-- ==========================================================
-- Scenario 3 : Generate Insurance Quote
-- ==========================================================

INSERT INTO mi_quote
(
customer_id,
vehicle_id,
broker_id,
product_id,
quote_date,
coverage_type,
basic_premium,
addon_amount,
tax_amount,
total_premium,
quote_status
)

VALUES
(
21,
21,
1,
2,
CURDATE(),
'Comprehensive',
9000,
1000,
1800,
11800,
'NEW'
);

SELECT *
FROM mi_quote
WHERE customer_id=21;

-- ==========================================================
-- Scenario 4 : Issue Insurance Policy
-- ==========================================================

INSERT INTO mi_policy
(
policy_number,
quote_id,
issue_date,
start_date,
expiry_date,
policy_status
)

VALUES
(
'POL2026001',
21,
CURDATE(),
CURDATE(),
DATE_ADD(CURDATE(),INTERVAL 1 YEAR),
'ACTIVE'
);

SELECT *
FROM mi_policy
WHERE quote_id=21;

-- ==========================================================
-- Scenario 5 : Customer Makes Payment
-- ==========================================================

INSERT INTO mi_payment
(
policy_id,
payment_date,
payment_method,
currency,
amount,
payment_status,
transaction_reference
)

VALUES
(
21,
NOW(),
'UPI',
'INR',
11800,
'SUCCESS',
'TXN2026001'
);

SELECT *
FROM mi_payment
WHERE policy_id=21;

-- ==========================================================
-- Scenario 6 : Submit Claim
-- ==========================================================

INSERT INTO mi_claim
(
policy_id,
claim_date,
accident_date,
claim_amount,
approved_amount,
claim_status,
remarks
)

VALUES
(
21,
CURDATE(),
DATE_SUB(CURDATE(),INTERVAL 2 DAY),
35000,
NULL,
'PENDING',
'Front Bumper Damage'
);

SELECT *
FROM mi_claim
WHERE policy_id=21;

-- ==========================================================
-- Scenario 7 : Approve Claim
-- ==========================================================

UPDATE mi_claim

SET

approved_amount=33000,
claim_status='APPROVED'

WHERE policy_id=21;

SELECT
claim_id,
claim_status,
approved_amount
FROM mi_claim
WHERE policy_id=21;

-- ==========================================================
-- Scenario 8 : Find Policies Expiring Within 30 Days
-- ==========================================================

SELECT

policy_number,
expiry_date

FROM mi_policy

WHERE expiry_date
BETWEEN CURDATE()
AND DATE_ADD(CURDATE(),INTERVAL 30 DAY)

ORDER BY expiry_date;

-- ==========================================================
-- Scenario 9 : Generate Broker Commission Report
-- ==========================================================

SELECT

b.broker_name,

COUNT(q.quote_id)
AS Total_Policies,

SUM(q.total_premium)
AS Total_Premium,

SUM(q.total_premium)*0.10
AS Commission

FROM mi_broker b

INNER JOIN mi_quote q

ON b.broker_id=q.broker_id

GROUP BY b.broker_name

ORDER BY Commission DESC;

-- ==========================================================
-- Scenario 10 : Top 10 Customers by Premium
-- ==========================================================

SELECT

c.customer_id,

CONCAT(c.first_name,' ',c.last_name)
AS Customer_Name,

SUM(pay.amount)
AS Total_Premium

FROM mi_customer c

INNER JOIN mi_quote q

ON c.customer_id=q.customer_id

INNER JOIN mi_policy p

ON q.quote_id=p.quote_id

INNER JOIN mi_payment pay

ON p.policy_id=pay.policy_id

GROUP BY c.customer_id,
Customer_Name

ORDER BY Total_Premium DESC

LIMIT 10;

USE motor_insurance_db;

-- ==========================================================
-- Scenario 11 : Policy Renewal
-- Business Requirement:
-- Renew a policy for another year.
-- ==========================================================

UPDATE mi_policy
SET
expiry_date = DATE_ADD(expiry_date, INTERVAL 1 YEAR),
policy_status = 'RENEWED'
WHERE policy_id = 10;

SELECT
policy_number,
expiry_date,
policy_status
FROM mi_policy
WHERE policy_id = 10;

-- ==========================================================
-- Scenario 12 : Find Expired Policies
-- ==========================================================

SELECT
policy_number,
customer_id,
expiry_date
FROM mi_policy p
INNER JOIN mi_quote q
ON p.quote_id=q.quote_id
WHERE expiry_date < CURDATE()
ORDER BY expiry_date;

-- ==========================================================
-- Scenario 13 : Vehicle-wise Insurance Report
-- ==========================================================

SELECT

v.registration_no,

mk.make_name,

md.model_name,

p.policy_number,

p.policy_status

FROM mi_vehicle v

INNER JOIN mi_vehicle_make mk
ON v.make_id=mk.make_id

INNER JOIN mi_vehicle_model md
ON v.model_id=md.model_id

INNER JOIN mi_quote q
ON v.vehicle_id=q.vehicle_id

INNER JOIN mi_policy p
ON q.quote_id=p.quote_id

ORDER BY mk.make_name;

-- ==========================================================
-- Scenario 14 : State-wise Customer Report
-- ==========================================================

SELECT

s.state_name,

COUNT(c.customer_id)
AS Total_Customers

FROM mi_customer c

INNER JOIN mi_state s

ON c.state_id=s.state_id

GROUP BY s.state_name

ORDER BY Total_Customers DESC;

-- ==========================================================
-- Scenario 15 : Customer Having Multiple Policies
-- ==========================================================

SELECT

c.customer_id,

CONCAT(c.first_name,' ',c.last_name)
AS Customer_Name,

COUNT(p.policy_id)
AS Total_Policies

FROM mi_customer c

INNER JOIN mi_quote q

ON c.customer_id=q.customer_id

INNER JOIN mi_policy p

ON q.quote_id=p.quote_id

GROUP BY c.customer_id

HAVING COUNT(p.policy_id)>=2;

-- ==========================================================
-- Scenario 16 : Highest Claim Amount
-- ==========================================================

SELECT

claim_id,

policy_id,

claim_amount,

claim_status

FROM mi_claim

WHERE claim_amount=

(
SELECT MAX(claim_amount)

FROM mi_claim
);

-- ==========================================================
-- Scenario 17 : Monthly Revenue Report
-- ==========================================================

SELECT

MONTH(payment_date)
AS Month_Number,

MONTHNAME(payment_date)
AS Month_Name,

SUM(amount)
AS Revenue

FROM mi_payment

GROUP BY

MONTH(payment_date),
MONTHNAME(payment_date)

ORDER BY Month_Number;

-- ==========================================================
-- Scenario 18 : Audit Log Report
-- ==========================================================

SELECT

operation_time,

table_name,

operation_type,

description

FROM mi_audit_log

ORDER BY operation_time DESC;

-- ==========================================================
-- Scenario 19 : Customer Policy History
-- ==========================================================

SELECT

c.customer_id,

CONCAT(c.first_name,' ',c.last_name)
AS Customer_Name,

p.policy_number,

p.start_date,

p.expiry_date,

p.policy_status

FROM mi_customer c

INNER JOIN mi_quote q

ON c.customer_id=q.customer_id

INNER JOIN mi_policy p

ON q.quote_id=p.quote_id

WHERE c.customer_id=5;

-- ==========================================================
-- Scenario 20 : Complete Insurance Dashboard
-- Business Dashboard
-- ==========================================================

SELECT

(SELECT COUNT(*) FROM mi_customer)
AS Total_Customers,

(SELECT COUNT(*) FROM mi_vehicle)
AS Total_Vehicles,

(SELECT COUNT(*) FROM mi_policy)
AS Total_Policies,

(SELECT COUNT(*) FROM mi_claim)
AS Total_Claims,

(SELECT SUM(amount)
FROM mi_payment)
AS Total_Revenue,

(SELECT AVG(final_premium)
FROM mi_premium)
AS Average_Premium;

USE motor_insurance_db;

-- ==========================================================
-- Procedure 1 : Register New Customer
-- ==========================================================

DELIMITER $$

CREATE PROCEDURE sp_register_customer
(
IN p_first_name VARCHAR(50),
IN p_last_name VARCHAR(50),
IN p_gender VARCHAR(10),
IN p_email VARCHAR(100),
IN p_mobile VARCHAR(20)
)

BEGIN

INSERT INTO mi_customer
(
first_name,
last_name,
gender,
email,
mobile
)

VALUES
(
p_first_name,
p_last_name,
p_gender,
p_email,
p_mobile
);

SELECT 'Customer Registered Successfully' AS Message;

END $$

DELIMITER ;

CALL sp_register_customer
(
'Kumar',
'Raj',
'Male',
'kumar@gmail.com',
'9876543211'
);

-- ==========================================================
-- Procedure 2 : Register Vehicle
-- ==========================================================

DELIMITER $$

CREATE PROCEDURE sp_add_vehicle
(
IN p_customer_id INT,
IN p_make_id INT,
IN p_model_id INT,
IN p_reg_no VARCHAR(20),
IN p_value DECIMAL(12,2)
)

BEGIN

INSERT INTO mi_vehicle
(
customer_id,
make_id,
model_id,
registration_no,
vehicle_value
)

VALUES
(
p_customer_id,
p_make_id,
p_model_id,
p_reg_no,
p_value
);

SELECT 'Vehicle Added Successfully' AS Message;

END $$

DELIMITER ;

CALL sp_add_vehicle
(
1,
2,
3,
'TN09AB9001',
1250000
);

-- ==========================================================
-- Procedure 3 : Generate Insurance Quote
-- ==========================================================

DELIMITER $$

CREATE PROCEDURE sp_generate_quote
(
IN p_customer INT,
IN p_vehicle INT,
IN p_product INT,
IN p_premium DECIMAL(10,2)
)

BEGIN

INSERT INTO mi_quote
(
customer_id,
vehicle_id,
product_id,
basic_premium,
quote_date,
quote_status
)

VALUES
(
p_customer,
p_vehicle,
p_product,
p_premium,
CURDATE(),
'NEW'
);

SELECT 'Quote Generated Successfully' AS Message;

END $$

DELIMITER ;

CALL sp_generate_quote(1,1,2,8500);

-- ==========================================================
-- Procedure 4 : Issue Policy
-- ==========================================================

DELIMITER $$

CREATE PROCEDURE sp_issue_policy
(
IN p_policy_no VARCHAR(30),
IN p_quote_id INT
)

BEGIN

INSERT INTO mi_policy
(
policy_number,
quote_id,
issue_date,
start_date,
expiry_date,
policy_status
)

VALUES
(
p_policy_no,
p_quote_id,
CURDATE(),
CURDATE(),
DATE_ADD(CURDATE(),INTERVAL 1 YEAR),
'ACTIVE'
);

SELECT 'Policy Issued Successfully' AS Message;

END $$

DELIMITER ;

CALL sp_issue_policy
(
'POL90001',
1
);

-- ==========================================================
-- Procedure 5 : Calculate GST
-- ==========================================================

DELIMITER $$

CREATE PROCEDURE sp_calculate_gst
(
IN p_amount DECIMAL(12,2)
)

BEGIN

SELECT

p_amount AS Premium,

p_amount*18/100 AS GST,

p_amount+(p_amount*18/100)
AS Total_Premium;

END $$

DELIMITER ;

CALL sp_calculate_gst(10000);

-- ==========================================================
-- Procedure 6 : Record Payment
-- ==========================================================

DELIMITER $$

CREATE PROCEDURE sp_make_payment
(
IN p_policy INT,
IN p_amount DECIMAL(12,2),
IN p_method VARCHAR(30)
)

BEGIN

INSERT INTO mi_payment
(
policy_id,
payment_date,
payment_method,
currency,
amount,
payment_status
)

VALUES
(
p_policy,
NOW(),
p_method,
'INR',
p_amount,
'SUCCESS'
);

SELECT 'Payment Successful' AS Message;

END $$

DELIMITER ;

CALL sp_make_payment
(
1,
10500,
'UPI'
);

-- ==========================================================
-- Procedure 7 : Submit Claim
-- ==========================================================

DELIMITER $$

CREATE PROCEDURE sp_submit_claim
(
IN p_policy INT,
IN p_claim DECIMAL(12,2)
)

BEGIN

INSERT INTO mi_claim
(
policy_id,
claim_date,
accident_date,
claim_amount,
claim_status
)

VALUES
(
p_policy,
CURDATE(),
CURDATE(),
p_claim,
'PENDING'
);

SELECT 'Claim Submitted' AS Message;

END $$

DELIMITER ;

CALL sp_submit_claim
(
1,
25000
);

-- ==========================================================
-- Procedure 8 : Approve Claim
-- ==========================================================

DELIMITER $$

CREATE PROCEDURE sp_approve_claim
(
IN p_claim_id INT,
IN p_amount DECIMAL(12,2)
)

BEGIN

UPDATE mi_claim

SET

approved_amount=p_amount,

claim_status='APPROVED'

WHERE claim_id=p_claim_id;

SELECT 'Claim Approved' AS Message;

END $$

DELIMITER ;

CALL sp_approve_claim
(
1,
24000
);

-- ==========================================================
-- Procedure 9 : Renew Policy
-- ==========================================================

DELIMITER $$

CREATE PROCEDURE sp_renew_policy
(
IN p_policy INT
)

BEGIN

UPDATE mi_policy

SET

expiry_date=DATE_ADD(expiry_date,INTERVAL 1 YEAR),

policy_status='RENEWED'

WHERE policy_id=p_policy;

SELECT 'Policy Renewed Successfully' AS Message;

END $$

DELIMITER ;

CALL sp_renew_policy
(
1
);

-- ==========================================================
-- Procedure 10 : Customer Policy History
-- ==========================================================

DELIMITER $$

CREATE PROCEDURE sp_customer_policy_history
(
IN p_customer INT
)

BEGIN

SELECT

c.customer_id,

CONCAT(c.first_name,' ',c.last_name)
AS Customer_Name,

p.policy_number,

p.start_date,

p.expiry_date,

p.policy_status

FROM mi_customer c

INNER JOIN mi_quote q
ON c.customer_id=q.customer_id

INNER JOIN mi_policy p
ON q.quote_id=p.quote_id

WHERE c.customer_id=p_customer;

END $$

DELIMITER ;

CALL sp_customer_policy_history
(
1
);

USE motor_insurance_db;

-- ==========================================================
-- Trigger 1 : BEFORE INSERT
-- Prevent Negative Premium
-- ==========================================================

DELIMITER $$

CREATE TRIGGER trg_before_insert_premium

BEFORE INSERT

ON mi_premium

FOR EACH ROW

BEGIN

IF NEW.final_premium < 0 THEN

SIGNAL SQLSTATE '45000'

SET MESSAGE_TEXT='Final Premium Cannot Be Negative';

END IF;

END $$

DELIMITER ;

-- ==========================================================
-- Trigger 2 : AFTER INSERT
-- Customer Audit Log
-- ==========================================================

DELIMITER $$

CREATE TRIGGER trg_after_customer_insert

AFTER INSERT

ON mi_customer

FOR EACH ROW

BEGIN

INSERT INTO mi_audit_log
(
user_id,
table_name,
operation_type,
operation_time,
ip_address,
description
)

VALUES
(
1,
'mi_customer',
'INSERT',
NOW(),
'127.0.0.1',
CONCAT('New Customer Added : ',NEW.first_name,' ',NEW.last_name)
);

END $$

DELIMITER ;

-- ==========================================================
-- Trigger 3 : BEFORE UPDATE
-- Prevent Negative Vehicle Value
-- ==========================================================

DELIMITER $$

CREATE TRIGGER trg_before_vehicle_update

BEFORE UPDATE

ON mi_vehicle

FOR EACH ROW

BEGIN

IF NEW.vehicle_value < 0 THEN

SIGNAL SQLSTATE '45000'

SET MESSAGE_TEXT='Vehicle Value Cannot Be Negative';

END IF;

END $$

DELIMITER ;

-- ==========================================================
-- Trigger 4 : AFTER UPDATE
-- Policy Audit
-- ==========================================================

DELIMITER $$

CREATE TRIGGER trg_after_policy_update

AFTER UPDATE

ON mi_policy

FOR EACH ROW

BEGIN

INSERT INTO mi_audit_log
(
user_id,
table_name,
operation_type,
operation_time,
ip_address,
description
)

VALUES
(
1,
'mi_policy',
'UPDATE',
NOW(),
'127.0.0.1',
CONCAT('Policy Updated : ',NEW.policy_number)
);

END $$

DELIMITER ;

-- ==========================================================
-- Trigger 5 : BEFORE DELETE
-- Prevent Deleting Active Policy
-- ==========================================================

DELIMITER $$

CREATE TRIGGER trg_before_policy_delete

BEFORE DELETE

ON mi_policy

FOR EACH ROW

BEGIN

IF OLD.policy_status='ACTIVE' THEN

SIGNAL SQLSTATE '45000'

SET MESSAGE_TEXT='Active Policy Cannot Be Deleted';

END IF;

END $$

DELIMITER ;

-- ==========================================================
-- Trigger 6 : AFTER DELETE
-- Customer Delete Audit
-- ==========================================================

DELIMITER $$

CREATE TRIGGER trg_after_customer_delete

AFTER DELETE

ON mi_customer

FOR EACH ROW

BEGIN

INSERT INTO mi_audit_log
(
user_id,
table_name,
operation_type,
operation_time,
ip_address,
description
)

VALUES
(
1,
'mi_customer',
'DELETE',
NOW(),
'127.0.0.1',
CONCAT('Customer Deleted : ',OLD.first_name,' ',OLD.last_name)
);

END $$

DELIMITER ;

-- ==========================================================
-- Trigger 7 : AFTER INSERT
-- Payment Success Audit
-- ==========================================================

DELIMITER $$

CREATE TRIGGER trg_after_payment_insert

AFTER INSERT

ON mi_payment

FOR EACH ROW

BEGIN

INSERT INTO mi_audit_log
(
user_id,
table_name,
operation_type,
operation_time,
ip_address,
description
)

VALUES
(
1,
'mi_payment',
'INSERT',
NOW(),
'127.0.0.1',
CONCAT('Payment Received : ',NEW.amount)
);

END $$

DELIMITER ;

-- ==========================================================
-- Trigger 8 : AFTER UPDATE
-- Claim Approval Audit
-- ==========================================================

DELIMITER $$

CREATE TRIGGER trg_after_claim_update

AFTER UPDATE

ON mi_claim

FOR EACH ROW

BEGIN

IF NEW.claim_status='APPROVED' THEN

INSERT INTO mi_audit_log
(
user_id,
table_name,
operation_type,
operation_time,
ip_address,
description
)

VALUES
(
1,
'mi_claim',
'UPDATE',
NOW(),
'127.0.0.1',
CONCAT('Claim Approved ID : ',NEW.claim_id)
);

END IF;

END $$

DELIMITER ;

-- ==========================================================
-- Trigger 9 : AFTER INSERT
-- Policy Creation Audit
-- ==========================================================

DELIMITER $$

CREATE TRIGGER trg_after_policy_insert

AFTER INSERT

ON mi_policy

FOR EACH ROW

BEGIN

INSERT INTO mi_audit_log
(
user_id,
table_name,
operation_type,
operation_time,
ip_address,
description
)

VALUES
(
1,
'mi_policy',
'INSERT',
NOW(),
'127.0.0.1',
CONCAT('Policy Issued : ',NEW.policy_number)
);

END $$

DELIMITER ;

-- ==========================================================
-- Trigger 10 : BEFORE UPDATE
-- Premium Validation
-- ==========================================================

DELIMITER $$

CREATE TRIGGER trg_before_premium_update

BEFORE UPDATE

ON mi_premium

FOR EACH ROW

BEGIN

IF NEW.final_premium < NEW.base_premium THEN

SIGNAL SQLSTATE '45000'

SET MESSAGE_TEXT='Final Premium Cannot Be Less Than Base Premium';

END IF;

END $$

DELIMITER ;

USE motor_insurance_db;

-- ==========================================================
-- View 1 : Customer Details View
-- ==========================================================

CREATE OR REPLACE VIEW vw_customer_details AS

SELECT

customer_id,
CONCAT(first_name,' ',last_name) AS Customer_Name,
gender,
email,
mobile,
occupation

FROM mi_customer;

SELECT * FROM vw_customer_details;

-- ==========================================================
-- View 2 : Vehicle Details View
-- ==========================================================

CREATE OR REPLACE VIEW vw_vehicle_details AS

SELECT

v.vehicle_id,
v.registration_no,
mk.make_name,
md.model_name,
c.color_name,
v.vehicle_value

FROM mi_vehicle v

INNER JOIN mi_vehicle_make mk
ON v.make_id=mk.make_id

INNER JOIN mi_vehicle_model md
ON v.model_id=md.model_id

INNER JOIN mi_vehicle_color c
ON v.color_id=c.color_id;

SELECT * FROM vw_vehicle_details;

-- ==========================================================
-- View 3 : Active Policy View
-- ==========================================================

CREATE OR REPLACE VIEW vw_active_policy AS

SELECT

policy_number,
issue_date,
start_date,
expiry_date,
policy_status

FROM mi_policy

WHERE policy_status='ACTIVE';

SELECT * FROM vw_active_policy;

-- ==========================================================
-- View 4 : Premium Report View
-- ==========================================================

CREATE OR REPLACE VIEW vw_premium_report AS

SELECT

premium_id,
quote_id,
base_premium,
addon_premium,
gst_amount,
discount_amount,
final_premium

FROM mi_premium;

SELECT * FROM vw_premium_report;

-- ==========================================================
-- View 5 : Payment Report View
-- ==========================================================

CREATE OR REPLACE VIEW vw_payment_report AS

SELECT

payment_id,
payment_date,
payment_method,
currency,
amount,
payment_status

FROM mi_payment;

SELECT * FROM vw_payment_report;

-- ==========================================================
-- View 6 : Claim Report View
-- ==========================================================

CREATE OR REPLACE VIEW vw_claim_report AS

SELECT

claim_id,
policy_id,
claim_amount,
approved_amount,
claim_status

FROM mi_claim;

SELECT * FROM vw_claim_report;

-- ==========================================================
-- View 7 : Broker Performance View
-- ==========================================================

CREATE OR REPLACE VIEW vw_broker_performance AS

SELECT

b.broker_name,

COUNT(q.quote_id)
AS Total_Quotes,

SUM(q.total_premium)
AS Total_Business

FROM mi_broker b

INNER JOIN mi_quote q

ON b.broker_id=q.broker_id

GROUP BY b.broker_name;

SELECT * FROM vw_broker_performance;

-- ==========================================================
-- View 8 : Renewal Report View
-- ==========================================================

CREATE OR REPLACE VIEW vw_renewal_report AS

SELECT

renewal_id,
policy_id,
renewal_date,
renewal_premium,
renewal_status

FROM mi_renewal;

SELECT * FROM vw_renewal_report;

-- ==========================================================
-- View 9 : Dashboard Summary View
-- ==========================================================

CREATE OR REPLACE VIEW vw_dashboard_summary AS

SELECT

(SELECT COUNT(*) FROM mi_customer)
AS Total_Customers,

(SELECT COUNT(*) FROM mi_vehicle)
AS Total_Vehicles,

(SELECT COUNT(*) FROM mi_policy)
AS Total_Policies,

(SELECT COUNT(*) FROM mi_claim)
AS Total_Claims,

(SELECT SUM(amount)
FROM mi_payment)
AS Total_Revenue;

SELECT * FROM vw_dashboard_summary;

-- ==========================================================
-- View 10 : Complete Insurance Report View
-- ==========================================================

CREATE OR REPLACE VIEW vw_complete_insurance_report AS

SELECT

c.customer_id,

CONCAT(c.first_name,' ',c.last_name)
AS Customer_Name,

v.registration_no,

mk.make_name,

md.model_name,

p.policy_number,

pay.amount,

pay.payment_status,

cl.claim_status

FROM mi_customer c

INNER JOIN mi_vehicle v
ON c.customer_id=v.customer_id

INNER JOIN mi_vehicle_make mk
ON v.make_id=mk.make_id

INNER JOIN mi_vehicle_model md
ON v.model_id=md.model_id

INNER JOIN mi_quote q
ON c.customer_id=q.customer_id

INNER JOIN mi_policy p
ON q.quote_id=p.quote_id

INNER JOIN mi_payment pay
ON p.policy_id=pay.policy_id

LEFT JOIN mi_claim cl
ON p.policy_id=cl.policy_id;

SELECT * FROM vw_complete_insurance_report;
