CREATE DATABASE PetYard;

CREATE TABLE Petowner (
    Owner_Id SERIAL PRIMARY KEY,
    First_name VARCHAR(225),
    Last_name VARCHAR(225),
    Password VARCHAR(225),
    ResetToken VARCHAR(225),
    Phone VARCHAR(225) UNIQUE, -- Making Phone unique
    Email VARCHAR(225) UNIQUE, -- Making Email unique
    Date_of_birth DATE,
    Location VARCHAR(225),
    Image VARCHAR(255) -- Assuming 255 characters for the image path or URL
);

CREATE TABLE ServiceProvider (
    Provider_Id SERIAL PRIMARY KEY,
    First_name VARCHAR(225),
    Last_name VARCHAR(225),
    Password VARCHAR(225),
    Phone VARCHAR(225) UNIQUE, -- Making Phone unique
    Email VARCHAR(225) UNIQUE, -- Making Email unique
    Bio VARCHAR(350) ,
    Date_of_birth DATE,
    Location VARCHAR(225),
    Image VARCHAR(255) -- Assuming 255 characters for the image path or URL
);



CREATE TYPE PetType AS ENUM ('Dog', 'Cat');


CREATE TABLE Pet (
    Pet_Id SERIAL PRIMARY KEY,
    Type VARCHAR(50),
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
