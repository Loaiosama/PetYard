CREATE DATABASE PetYard;

/* psql -U postgres

    password
    \c PetYard

    7ot el tables
*/



CREATE TABLE Petowner (
    Owner_Id SERIAL PRIMARY KEY,
    First_name VARCHAR(225),
    Last_name VARCHAR(225),
    Password VARCHAR(225),
    ResetToken VARCHAR(225),
    Phone VARCHAR(225) UNIQUE, -- Making Phone unique
    Email VARCHAR(225) UNIQUE, -- Making Email unique
    Date_of_birth DATE,
    Location POINT,
    Image VARCHAR(255) -- Assuming 255 characters for the image path or URL
);

CREATE TABLE ServiceProvider (
    Provider_Id SERIAL PRIMARY KEY,
    UserName VARCHAR(225) UNIQUE, 
    Password VARCHAR(225),
    Phone VARCHAR(225) UNIQUE, -- Making Phone unique
    Email VARCHAR(225) UNIQUE, -- Making Email unique
    Bio VARCHAR(350) ,
    ResetToken VARCHAR(225),
    Date_of_birth DATE,
    Location POINT,
    Image VARCHAR(255) -- Assuming 255 characters for the image path or URL
);


CREATE TYPE PetType AS ENUM ('Dog', 'Cat');


CREATE TABLE Pet (
    Pet_Id SERIAL PRIMARY KEY,
    Type PetType,
    Name VARCHAR(50),
    Gender VARCHAR(50),
    Breed VARCHAR(50),
    Date_of_birth DATE,
    Adoption_Date DATE,
    Weight DOUBLE PRECISION, 
    Image VARCHAR(255), 
    Bio VARCHAR(350) ,
    Owner_Id INTEGER,
    FOREIGN KEY (Owner_Id) REFERENCES PetOwner(Owner_Id)
);

CREATE TYPE ServiceType AS ENUM ('Walking', 'Grooming', 'Boarding', 'Sitting', 'Clinic');

CREATE TABLE Services (
    Service_ID SERIAL PRIMARY KEY,
    Provider_ID INT REFERENCES ServiceProvider(Provider_Id),
    Type ServiceType
);

CREATE TABLE ServiceSlots (
    Slot_ID SERIAL PRIMARY KEY,
    Provider_ID INT,
    Service_ID INT,
    Start_time TIMESTAMP,
    End_time TIMESTAMP,
    Price DOUBLE PRECISION,
    FOREIGN KEY (Service_ID) REFERENCES Services(Service_ID),
    FOREIGN KEY (Provider_ID) REFERENCES ServiceProvider(Provider_Id)
);

CREATE TYPE Status AS ENUM ('Accepted', 'Pending', 'Rejected','Completed');

CREATE TABLE Reservation (
    Reserve_ID SERIAL PRIMARY KEY,
    Slot_ID INT,
    Pet_ID INT,
    Owner_ID INT,
    Start_time TIMESTAMP,
    End_time TIMESTAMP,
    expirationTime BIGINT,
    Final_Price DOUBLE PRECISION,
    Type Status DEFAULT 'Pending',
    FOREIGN KEY (Slot_ID) REFERENCES ServiceSlots(Slot_ID),
    FOREIGN KEY (Owner_ID) REFERENCES Petowner(Owner_Id),
    FOREIGN KEY (Pet_ID) REFERENCES Pet(Pet_ID)
);

CREATE TABLE SittingReservation (
    Reserve_ID SERIAL PRIMARY KEY,
    Pet_ID INT,
    Owner_ID INT,
    Location POINT,
    Start_time TIMESTAMP  WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP ,
    End_time TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expirationTime BIGINT,
    Final_Price DOUBLE PRECISION,
    Status VARCHAR(20) DEFAULT 'Pending',
    Provider_ID INT,  -- Nullable, will be set when the owner accepts a provider
    FOREIGN KEY (Owner_ID) REFERENCES Petowner(Owner_Id),
    FOREIGN KEY (Pet_ID) REFERENCES Pet(Pet_ID),
    FOREIGN KEY (Provider_ID) REFERENCES ServiceProvider(Provider_Id)
);

-- Table to handle applications from service providers for a sitting reservation
CREATE TABLE SittingApplication (
    Application_ID SERIAL PRIMARY KEY,
    Reserve_ID INT,
    Provider_ID INT,
    Application_Status Status DEFAULT 'Pending',
    Application_Date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Reserve_ID) REFERENCES SittingReservation(Reserve_ID),
    FOREIGN KEY (Provider_ID) REFERENCES ServiceProvider(Provider_Id)
);



CREATE TYPE GroomingType AS ENUM ('Bathing', 'Nail trimming', 'Fur trimming','Full package');

CREATE TABLE GroomingServiceSlots (
    Slot_ID SERIAL PRIMARY KEY,
    Provider_ID INT,
    Start_time TIMESTAMP,
    End_time TIMESTAMP,
    Price DOUBLE PRECISION,
    Grooming_Type GroomingType,
    Type Status DEFAULT 'Pending',
    FOREIGN KEY (Provider_ID) REFERENCES ServiceProvider(Provider_Id)
);


CREATE TABLE GroomingReservation (
    Reserve_ID SERIAL PRIMARY KEY,
    Slot_ID INT,
    Pet_ID INT,
    Owner_ID INT,
    Start_time TIMESTAMP,
    End_time TIMESTAMP,
    Final_Price DOUBLE PRECISION,
    Grooming_Type GroomingType,
    FOREIGN KEY (Slot_ID) REFERENCES GroomingServiceSlots(Slot_ID),
    FOREIGN KEY (Owner_ID) REFERENCES Petowner(Owner_Id),
    FOREIGN KEY (Pet_ID) REFERENCES Pet(Pet_ID)
);


CREATE TABLE ProviderGroomingTypes (
    ID SERIAL PRIMARY KEY,
    Provider_ID INT,
    Grooming_Type GroomingType,
    FOREIGN KEY (Provider_ID) REFERENCES ServiceProvider(Provider_ID)
);



CREATE TABLE Review (
    Rating_ID SERIAL PRIMARY KEY,
    Reservation_ID INT,
    Rate_value DOUBLE PRECISION,
    FOREIGN KEY (Reservation_ID) REFERENCES Reservation(Reserve_ID)
);

CREATE TABLE Comment (
    Rating_ID INT,
    Comment_ID SERIAL PRIMARY KEY,
    Comment VARCHAR(255),
    FOREIGN KEY (Rating_ID) REFERENCES Review(Rating_ID)
);



-- Create the Chat table with an array of integers for the Members column

CREATE TABLE Chat (
    Chat_ID SERIAL PRIMARY KEY,
    Members INTEGER[], -- Array of integers to store member IDs
    Owner_ID INTEGER REFERENCES Petowner(Owner_Id),
    Provider_ID INTEGER REFERENCES ServiceProvider(Provider_Id)
);

CREATE TABLE Messages (
    Message_id SERIAL PRIMARY KEY,
    Sender_id INT NOT NULL,
    Chat_Id INT,
    text TEXT, 
    FOREIGN KEY (Chat_Id) REFERENCES Chat(Chat_ID)
);


CREATE TYPE category AS ENUM ('Accessories','Food');

CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    Type  category,
    brand VARCHAR(100),
    Price DOUBLE PRECISION,
    stock_quantity INT DEFAULT 0,
    Image VARCHAR(255) NOT NULL, 
    Provider_ID INT ,
    FOREIGN KEY (Provider_ID) REFERENCES ServiceProvider(Provider_Id)
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    total_amount DOUBLE PRECISION ,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Owner_ID INT,
    FOREIGN KEY (Owner_ID) REFERENCES Petowner(Owner_Id)
);

CREATE TABLE OrderItems (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price_per_unit DOUBLE PRECISION NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TYPE Pay AS ENUM ('Cash','Online');

CREATE TABLE Shipping (
    shipping_id SERIAL PRIMARY KEY,
    type Pay,
    order_id INT,
    location POINT,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    phone VARCHAR(225) NOT NULL,
    address VARCHAR(500) NOT NULL,
    status BOOLEAN DEFAULT FALSE, -- FALSE indicates the order is not received, TRUE indicates it is received
    paid BOOLEAN DEFAULT FALSE, -- FALSE indicates the order is not paid, TRUE indicates it is paid
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);



CREATE TABLE Followers (
    id SERIAL PRIMARY KEY,
    Follower_ID INTEGER NOT NULL,
    Follower_Type VARCHAR(50) NOT NULL,
    Followee_ID INTEGER NOT NULL,
    Followee_Type VARCHAR(50) NOT NULL,
    UNIQUE (Follower_ID, Follower_Type, Followee_ID, Followee_Type)
);


CREATE TABLE Posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    user_type VARCHAR(50) NOT NULL CHECK (user_type IN ('Petowner', 'ServiceProvider')),
    image VARCHAR(255) NOT NULL,
    description TEXT,
    likes JSONB DEFAULT '{}'::JSONB,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

/*
CREATE TABLE Location (
    id SERIAL PRIMARY KEY,
    lat NUMERIC,
    lng NUMERIC
);
*/