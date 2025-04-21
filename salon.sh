#! /bin/bash

# salon appointment scheduler script

# connect to salon database
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

valid_phone_num='[0-9]{3}-[0-9]{3}-[0-9]{4}'
int_in_str='.*[0-9].*'
valid_time1='^(1[0-2]|[1-9]):[0-5][0-9]$'
valid_time2='^(1[0-2]|[1-9])(am|pm|AM|PM)$'
do_not_show_new_customer_insert_statement=''

# function that displays main menu
main_menu () {
  # echo -e "\nWelcome to My Salon, how can I help you?\n"
  echo "$($PSQL "SELECT * FROM services;")" | sed 's/|/) /'
  # echo -e "4) Exit"
}

get_user_input () {

local cont_loop=true

while [ cont_loop=true ];
do
read SERVICE_ID_SELECTED
  if [[ $SERVICE_ID_SELECTED == 1 ]];
    then
      # echo "You have selected Haircut"
      break
  elif [[ $SERVICE_ID_SELECTED == 2 ]];
    then
      # echo "You have selected Manicure"
      break
  elif [[ $SERVICE_ID_SELECTED == 3 ]];
    then
      # echo "You have selected Pedicure"
      break
  elif [[ $SERVICE_ID_SELECTED == 4 ]];
    then
      # echo -e "Good-bye"
      # exit
      break
  elif [[ $SERVICE_ID_SELECTED == 5 ]];
    then
    break
  else 
    echo -e "\nI could not find that service. What would you like today?"
    main_menu
  fi
done

# echo -e "loop1 is done\n"

echo -e "\nWhat's your phone number?"
while [ cont_loop=true ];
do
read CUSTOMER_PHONE
  if [[ $CUSTOMER_PHONE =~ $valid_phone_num ]];
    then
    # echo $CUSTOMER_PHONE
      break
  else 
    echo "Please enter a valid phone number:"
    continue
  fi
done

# echo -e "loop2 is done\n"

# check if customer is already in salon database, if not, add them
cust_exists="$($PSQL "SELECT * FROM customers WHERE phone = '$CUSTOMER_PHONE';")"

if [[ -z $cust_exists ]];
then

echo -e "\nI don't have a record for that phone number, what's your name?"

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
  # add new customer to salon database
 echo "$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")" | $do_not_show_new_customer_insert_statement
#  echo -e "Welcome new customer!\n"
fi

echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
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

# echo -e "loop4 is done\n"

# check if customer is already in salon database, if not, add them
cust_exists="$($PSQL "SELECT * FROM customers WHERE phone = '$CUSTOMER_PHONE';")"

if [[ -z $cust_exists ]];
then
  # add new customer to salon database
 echo "$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")" | $do_not_show_new_customer_insert_statement
#  echo -e "Welcome new customer!\n"
fi

}

create_appointment () {
  # to add row to appointments column,
  # query db to get customer_id associated with $CUSTOMER_PHONE,
  customer_id="$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")"
  service_name="$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED';")"
  echo "$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ('$customer_id', '$SERVICE_ID_SELECTED', '$SERVICE_TIME');")" | $do_not_show_new_customer_insert_statement

  # appointment confirmation
  echo -e "\nI have put you down for a $service_name at $SERVICE_TIME, $CUSTOMER_NAME."
}

echo -e "\n~~~~ MY SALON ~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?\n"
main_menu
get_user_input
create_appointment

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

