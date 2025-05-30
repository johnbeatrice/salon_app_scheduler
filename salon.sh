#! /bin/bash

# salon appointment scheduler script

# connect to salon database
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

valid_phone_num='[0-9]{3}-[0-9]{3}-[0-9]{4}'
int_in_str='.*[0-9].*'
valid_time1='^(1[0-2]|[1-9]):[0-5][0-9]$'
valid_time2='^(1[0-2]|[1-9])(am|pm|AM|PM)$'
do_not_show_new_customer_insert_statement=''
# cust_in_db=0
cust_name=''
declare -a cust_info

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
      cust_selection=cut
      break
  elif [[ $SERVICE_ID_SELECTED == 2 ]];
    then
      # echo "You have selected Manicure"
      cust_selection=color
      break
  elif [[ $SERVICE_ID_SELECTED == 3 ]];
    then
      # echo "You have selected Pedicure"
      cust_selection=perm
      break
  elif [[ $SERVICE_ID_SELECTED == 4 ]];
    then
      # echo -e "Good-bye"
      # exit
      cust_selection=style
      break
  elif [[ $SERVICE_ID_SELECTED == 5 ]];
    then
    cust_selection=trim
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

# echo $cust_exists

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
  # add new customer to customers table
 echo "$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")" | $do_not_show_new_customer_insert_statement
#  echo -e "Welcome new customer!\n"
  cust_name=$CUSTOMER_NAME
else
  IFS='|'
  read -ra cust_info <<< $cust_exists
  unset IFS
  # cust_in_db=1
  cust_name=${cust_info[1]}
  # echo ${cust_info[@]}
fi

echo -e "\nWhat time would you like your $cust_selection, $cust_name?"
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

}

create_appointment () {
  # to add row to appointments column,
  # query db to get customer_id associated with $CUSTOMER_PHONE,
  customer_id="$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")"
  # service_name="$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED';")"
  echo "$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ('$customer_id', '$SERVICE_ID_SELECTED', '$SERVICE_TIME');")" | $do_not_show_new_customer_insert_statement

  # appointment confirmation
  echo -e "\nI have put you down for a $cust_selection at $SERVICE_TIME, $cust_name."
}

echo -e "\n~~~~ MY SALON ~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"
main_menu
get_user_input
create_appointment
