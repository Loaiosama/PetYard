CREATE DATABASE PetYard;

CREATE TABLE Petowner (
    Owner_Id SERIAL PRIMARY KEY,
    First_name VARCHAR(15),
    Last_name VARCHAR(15),
    Password VARCHAR(15),
    Phone VARCHAR(15) UNIQUE, -- Making Phone unique
    Email VARCHAR(225) UNIQUE, -- Making Email unique
    Date_of_birth DATE,
    Location VARCHAR(100),
    Image VARCHAR(255) -- Assuming 255 characters for the image path or URL
);

CREATE TABLE ServiceProvider (
    Provider_Id SERIAL PRIMARY KEY,
    First_name VARCHAR(15),
    Last_name VARCHAR(15),
    Password VARCHAR(15),
    Phone VARCHAR(15) UNIQUE, -- Making Phone unique
    Email VARCHAR(225) UNIQUE, -- Making Email unique
    Bio VARCHAR(350) ,
    Date_of_birth DATE,
    Location VARCHAR(100),
    Image VARCHAR(255) -- Assuming 255 characters for the image path or URL
);