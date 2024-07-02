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
    expirationTime BIGINT,
    Application_Status Status DEFAULT 'Pending',
    Application_Date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Reserve_ID) REFERENCES SittingReservation(Reserve_ID),
    FOREIGN KEY (Provider_ID) REFERENCES ServiceProvider(Provider_Id)
);


CREATE TYPE GroomingType AS ENUM ('Bathing', 'Nail trimming', 'Fur trimming', 'Full package');

CREATE TABLE GroomingServiceSlots (
    Slot_ID SERIAL PRIMARY KEY,
    Provider_ID INT,
    Start_time TIMESTAMP,
    End_time TIMESTAMP,
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
    Grooming_Types GroomingType[],
    FOREIGN KEY (Slot_ID) REFERENCES GroomingServiceSlots(Slot_ID),
    FOREIGN KEY (Owner_ID) REFERENCES Petowner(Owner_Id),
    FOREIGN KEY (Pet_ID) REFERENCES Pet(Pet_ID)
);

CREATE TABLE ProviderGroomingTypes (
    ID SERIAL PRIMARY KEY,
    Provider_ID INT,
    Grooming_Type GroomingType,
    Price DOUBLE PRECISION,
    FOREIGN KEY (Provider_ID) REFERENCES ServiceProvider(Provider_ID)
);

CREATE TYPE ClinicType AS ENUM ('examinations', 'Lab testing', 'Vaccinations', 'Parasite prevention','Behavioral counseling','Training and socialization','Diet and nutrition','Dental health and cleaning');


CREATE TABLE ClinicServiceSlots (
    Slot_ID SERIAL PRIMARY KEY,
    Provider_ID INT,
    Start_time TIMESTAMP,
    End_time TIMESTAMP,
    Type Status DEFAULT 'Pending',
    FOREIGN KEY (Provider_ID) REFERENCES ServiceProvider(Provider_Id)
);

CREATE TABLE ClinicReservation (
    Reserve_ID SERIAL PRIMARY KEY,
    Slot_ID INT,
    Pet_ID INT,
    Owner_ID INT,
    Start_time TIMESTAMP,
    End_time TIMESTAMP,
    Final_Price DOUBLE PRECISION,
    Clinic_Type ClinicType[],
    FOREIGN KEY (Slot_ID) REFERENCES ClinicServiceSlots(Slot_ID),
    FOREIGN KEY (Owner_ID) REFERENCES Petowner(Owner_Id),
    FOREIGN KEY (Pet_ID) REFERENCES Pet(Pet_ID)
);

CREATE TABLE ProviderClinicTypes (
    ID SERIAL PRIMARY KEY,
    Provider_ID INT,
    Clinic_Type ClinicType,
    Price DOUBLE PRECISION,
    FOREIGN KEY (Provider_ID) REFERENCES ServiceProvider(Provider_ID)
);


CREATE TABLE WalkingRequest (
    Reserve_ID SERIAL PRIMARY KEY,
    Pet_ID INT,
    Owner_ID INT,
    Start_time TIMESTAMP  WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP ,
    End_time TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    Final_Price DOUBLE PRECISION,
    Status VARCHAR(20) DEFAULT 'Pending',
    Provider_ID INT,  -- Nullable, will be set when the owner accepts a provider
    FOREIGN KEY (Owner_ID) REFERENCES Petowner(Owner_Id),
    FOREIGN KEY (Pet_ID) REFERENCES Pet(Pet_ID),
    FOREIGN KEY (Provider_ID) REFERENCES ServiceProvider(Provider_Id)
);

-- Table to handle applications from service providers for a sitting reservation
CREATE TABLE WalkingApplication (
    Application_ID SERIAL PRIMARY KEY,
    Reserve_ID INT,
    Provider_ID INT,
    expirationTime BIGINT,
    Application_Status Status DEFAULT 'Pending',
    Application_Date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Reserve_ID) REFERENCES SittingReservation(Reserve_ID),
    FOREIGN KEY (Provider_ID) REFERENCES ServiceProvider(Provider_Id)
);



CREATE TABLE Review (
    Review_ID SERIAL PRIMARY KEY,
    Provider_ID INT,
    Rate_value DOUBLE PRECISION CHECK (Rate_value >= 0 AND Rate_value <= 5),
    count INT DEFAULT 0,
    FOREIGN KEY (Provider_ID) REFERENCES ServiceProvider(Provider_ID)
);

CREATE TABLE IndividualReviews (
    Review_ID SERIAL PRIMARY KEY,
    Provider_ID INT,
    Owner_ID INT,
    Rate_value DOUBLE PRECISION CHECK (Rate_value >= 0 AND Rate_value <= 5),
    Comment TEXT,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Provider_ID) REFERENCES ServiceProvider(Provider_ID),
    FOREIGN KEY (Owner_ID) REFERENCES Petowner(Owner_Id)
);



CREATE TABLE LocationUpdates (
    Update_ID SERIAL PRIMARY KEY,
    Service_Provider_ID INT NOT NULL,
    Latitude DOUBLE PRECISION NOT NULL,
    Longitude DOUBLE PRECISION NOT NULL,
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Service_Provider_ID) REFERENCES ServiceProvider(Provider_Id)
);

CREATE TABLE Geofence (
    Geofence_ID SERIAL PRIMARY KEY,
    PetOwner_ID INT NOT NULL,
    Center_Latitude DOUBLE PRECISION NOT NULL,
    Center_Longitude DOUBLE PRECISION NOT NULL,
    Radius DOUBLE PRECISION NOT NULL,
    FOREIGN KEY (PetOwner_ID) REFERENCES PetOwner(Owner_Id)
);

CREATE TABLE Notifications (
    Notification_ID SERIAL PRIMARY KEY,
    User_ID INT NOT NULL,
    User_Type VARCHAR(50) NOT NULL CHECK (User_Type IN ('PetOwner', 'ServiceProvider')),
    Message TEXT NOT NULL,
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (User_ID) REFERENCES PetOwner(Owner_Id) -- Adjust as needed for different user types
);

/*
CREATE TABLE Location (
    id SERIAL PRIMARY KEY,
    lat NUMERIC,
    lng NUMERIC
);
*/