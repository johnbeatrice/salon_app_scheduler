#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~ Salon Appointment Scheduler ~~\n"


# MAIN_MENU function opens when salon.sh is run
# "Enter the number of the service you would like to book"
# display services name and service_ids
# wait for user input, 
# check if user input is valid (case statement)
# else display error message and services options again
# maybe use a loop for this?
# while valid_answer=false
#   case/if statement with conditions
#   when valid answer set valid_answer to true
# use a loop for every customer input you need, keep looping until
# they give you valid inputs

# once you have all the customer/appointment info,
# check if customer exists in the customer table, if not, add them
# then create row in appointments table

# to check if customer already exists, check their phone number


# after user inputs service_id
# run get_customer_info function 







