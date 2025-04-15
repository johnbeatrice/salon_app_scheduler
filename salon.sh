#! /bin/bash

# salon appointment scheduler script

# connect to salon database
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

valid_phone_num='[0-9]{3}-[0-9]{3}-[0-9]{4}'
int_in_str='.*[0-9].*'
valid_time1='^(1[0-2]|[1-9]):[0-5][0-9]$'
valid_time2='^(1[0-2]|[1-9])(am|pm|AM|PM)$'

# function that displays main menu
main_menu () {
  echo -e "\nPlease type the number of the service\n you would like to schedule:\n"
  echo "$($PSQL "SELECT * FROM services;")" | sed 's/|/) /'
  echo -e "4) Exit\n"
}

get_user_input () {

local cont_loop=true

while [ cont_loop=true ];
do
read SERVICE_ID_SELECTED
  if [[ $SERVICE_ID_SELECTED == 1 ]];
    then
      echo "You have selected Haircut"
      break
  elif [[ $SERVICE_ID_SELECTED == 2 ]];
    then
      echo "You have selected Manicure"
      break
  elif [[ $SERVICE_ID_SELECTED == 3 ]];
    then
      echo "You have selected Pedicure"
      break
  elif [[ $SERVICE_ID_SELECTED == 4 ]];
    then
      echo -e "Good-bye"
      exit
  else 
    # echo "Please enter a valid input"
    main_menu
  fi
done

echo -e "loop1 is done\n"

echo "Please enter your phone number in the format of 555-555-5555"
while [ cont_loop=true ];
do
read CUSTOMER_PHONE
  if [[ $CUSTOMER_PHONE =~ $valid_phone_num ]];
    then
      break
  else 
    echo "Please enter a valid phone number:"
    continue
  fi
done

echo -e "loop2 is done\n"

echo "Please enter your name:"
while [ cont_loop=true ];
do
read CUSTOMER_NAME
  if [[ -n $CUSTOMER_NAME && ! $CUSTOMER_NAME =~ $int_in_str ]];
    then
      break
  else 
    echo "Please enter your name:"
    continue
  fi
done

echo -e "loop3 is done\n"

echo "Please enter the preferred time for your appointment:"
while [ cont_loop=true ];
do
read SERVICE_TIME
  if [[ $SERVICE_TIME =~ $valid_time1 || $SERVICE_TIME =~ $valid_time2 ]];
    then
      break
  else 
    echo "Please enter a valid time:"
    continue
  fi
done

echo -e "loop4 is done\n"

}

echo -e "\n~~ Salon Appointment Scheduler ~~\n"
main_menu
get_user_input

# main_menu function will display welcome message and appointment options

# get_user_input function will contain the loops to get all user input
# it will query the db to check whether the customer is new
# if customer is new, add customer to customers table
# then add info as new row to appointments table
# then display the successful appointment booking message
# then exit the script
# (it will be called within main_menu after main_menu displays the services options)

# exit function will be called within main_menu in the case that the user
# enters the exit code instead of a valid service_id
# it will display a goodbye/exit message and then terminate the script

