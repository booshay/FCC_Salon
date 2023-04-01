#! /bin/bash
echo -e "\n~~~~~ MY SALON ~~~~~\n"
PSQL="psql --username=freecodecamp --dbname=salon -t --tuples-only -c"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

SERVICES_OFFERED=$($PSQL "SELECT * FROM services")

echo -e "\nHere are our services:"

echo "$SERVICES_OFFERED" | while read SERVICE_ID BAR NAME
  do
    if [[ $SERVICE_ID =~ ^[0-9]+$ ]]
    then
      echo "$SERVICE_ID) $NAME"
    fi
  done
APPOINTMENT_MENU
}

APPOINTMENT_MENU() {
echo -e "\nPlease choose a service"
read SERVICE_ID_SELECTED
if [[ $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then

SELECTED_SERVICE_RESULT=$($PSQL "SELECT name from services WHERE service_id='$SERVICE_ID_SELECTED'")
  if [[ -z $SELECTED_SERVICE_RESULT ]]
  then 
    MAIN_MENU "Not a valid selection, please choose a service number below:"
  fi


echo -e "\nPlease enter your phone number :"
read CUSTOMER_PHONE
CUSTOMER_PHONE_RESULT=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

#check if customer exists
if [[ -z $CUSTOMER_PHONE_RESULT ]]
then
#doesn't exist
echo -e "\nThat number doesn't exist. Please enter your name."
read CUSTOMER_NAME
ADD_CUSTOMER_RESULT=$($PSQL"INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
echo -e "\nWelcome to your first visit $CUSTOMER_NAME.  What time would you like your appointment"
else
echo -e "\nWelcome back $CUSTOMER_PHONE_RESULT. What time would you like your appointment?"
fi
read SERVICE_TIME
CUSTOMER_RESULT=$($PSQL "SELECT * FROM customers WHERE phone='$CUSTOMER_PHONE'")
echo $CUSTOMER_RESULT | while read CUSTOMER_ID BAR CUSTOMER_PHONE BAR CUSTOMER_NAME
  do
    if [[ $CUSTOMER_ID =~ ^[0-9]+$ ]]
    then
      ADD_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      echo -e "\nI have put you down for a$SELECTED_SERVICE_RESULT at $SERVICE_TIME, $CUSTOMER_NAME."
      exit
    fi
  done
  else
  MAIN_MENU "Entry has to be a number only."
 fi
}
MAIN_MENU 
