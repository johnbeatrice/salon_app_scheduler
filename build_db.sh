#! /bin/bash

# run this file to build the salon database and insert some dummy data

PSQL1="psql --username=freecodecamp --dbname=postgres -t --no-align -c"
PSQL2="psql --username=freecodecamp --dbname=salon -t --no-align -c"

# create database
echo "$($PSQL1 "CREATE DATABASE salon;")"

# create customers table
echo "$($PSQL2 "CREATE TABLE customers(customer_id SERIAL PRIMARY KEY, name VARCHAR(50) NOT NULL, phone VARCHAR(14) UNIQUE);")"

# create appointments table
echo "$($PSQL2 "CREATE TABLE appointments(appointment_id SERIAL PRIMARY KEY, customer_id INT NOT NULL, service_id INT NOT NULL, time VARCHAR(7));")"

# create services table
echo "$($PSQL2 "CREATE TABLE services(service_id SERIAL PRIMARY KEY, name VARCHAR(30) NOT NULL);")"

# add foreign keys customer_id and service_id to appointments table
echo "$($PSQL2 "ALTER TABLE appointments ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id),  ADD FOREIGN KEY (service_id) REFERENCES services(service_id);")"

# insert values into customers
echo "$($PSQL2 "INSERT INTO customers (name, phone) VALUES('John Smith', '555-123-4567'), ('Jane Doe', '555-987-6543'), ('Robert Jones', '555-246-8012');")"

# insert values into services
echo "$($PSQL2 "INSERT INTO services (name) VALUES('Haircut'), ('Manicure'), ('Pedicure');")"

# appointments table will start as empty