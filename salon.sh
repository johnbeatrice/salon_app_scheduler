#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~ Salon Appointment Scheduler ~~\n"



main_menu function will display welcome message and appointment options

get_user_input function will contain the loops to get all user input
it will query the db to check whether the customer is new
if customer is new, add customer to customers table
then add info as new row to appointments table
then display the successful appointment booking message
then exit the script
(it will be called within main_menu after main_menu displays the services options)

exit function will be called within main_menu in the case that the user
enters the exit code instead of a valid service_id
it will display a goodbye/exit message and then terminate the script

