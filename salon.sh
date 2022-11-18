#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
#Book Salon Service
echo -e "\n~~~~ Salon Service ~~~~\n"

MAIN_MENU() {
if [[ $1 ]]
then
  echo -e "\n$1"
fi
echo -e "\nWhat Service do you want ?"
SERVICE_SELECT=$($PSQL "SELECT service_id, name FROM services")
echo "$SERVICE_SELECT" | while read SERVICE_ID BAR SERVICE
do
  echo -e "\n$SERVICE_ID) $SERVICE"
done
read SERVICE_ID_SELECTED
CHECK_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $CHECK_SERVICE ]]
then
  MAIN_MENU "Please enter a valid option."
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nGreating new customer, What's your name?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
    echo -e "\nWhat time suit you best?"
    read SERVICE_TIME
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
fi
}
MAIN_MENU