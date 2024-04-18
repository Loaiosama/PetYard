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
    Start_time DATE,
    End_time DATE,
    Price DOUBLE PRECISION,
    FOREIGN KEY (Service_ID) REFERENCES Services(Service_ID),
    FOREIGN KEY (Provider_ID) REFERENCES ServiceProvider(Provider_Id)
);

CREATE TABLE Reservation (
    Reserve_ID SERIAL PRIMARY KEY,
    Slot_ID INT,
    Pet_ID INT,
    Owner_ID INT,
    Date DATE,
    Status BOOLEAN,
    FOREIGN KEY (Slot_ID) REFERENCES ServiceSlots(Slot_ID),
    FOREIGN KEY (Owner_ID) REFERENCES Petowner(Owner_Id),
    FOREIGN KEY (Pet_ID) REFERENCES Pet(Pet_ID)
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



CREATE TABLE Chat (
   
    Chat_ID SERIAL PRIMARY KEY,
    Provider_ID INT,
    Owner_ID INT,
    FOREIGN KEY (Owner_ID) REFERENCES Petowner(Owner_Id),
    FOREIGN KEY (Provider_ID) REFERENCES ServiceProvider(Provider_Id)
);


CREATE TABLE Messages (
    Sender_id SERIAL PRIMARY KEY,
    Chat_Id INT,
    text VARCHAR(5000),
    FOREIGN KEY (Chat_Id) REFERENCES Chat(Chat_ID)
);


/*

Each Product is associated with a User (provider) who added the product (provider_id).
Each Order is linked to a User who placed the order (user_id).
OrderItems represent the products included in each order (product_id).


*/

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
    Type Pay,
    order_id INT,
    Location POINT,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    Phone VARCHAR(225) UNIQUE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

