#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#check to see if there is an argument passed into the script
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
  exit
fi

#check if input is an int or string
if [[ $1 =~ ^[0-9]+$ ]]
then
  #check if the int input is within the database
  LOOKUP_ELEMENT_RESULT=$($PSQL "select atomic_number from elements where atomic_number=$1")
else
  #check if the string input is within the database
  LOOKUP_ELEMENT_RESULT=$($PSQL "select atomic_number from elements where name='$1' or symbol='$1'")
fi

#check lookup query
if [[ -z $LOOKUP_ELEMENT_RESULT ]]
then
  #if nothing is found
  echo "I could not find that element in the database."
else
  #if found - provide info
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number=$LOOKUP_ELEMENT_RESULT")
  ATOMIC_SYMBOL=$($PSQL "select symbol from elements where atomic_number=$LOOKUP_ELEMENT_RESULT")
  ATOMIC_NAME=$($PSQL "select name from elements where atomic_number=$LOOKUP_ELEMENT_RESULT")
  ATOMIC_TYPE_ID=$($PSQL "select type_id from properties where atomic_number=$LOOKUP_ELEMENT_RESULT")
  ATOMIC_TYPE=$($PSQL "select type from types where type_id=$ATOMIC_TYPE_ID")
  ATOMIC_MASS=$($PSQL "select atomic_mass from properties where atomic_number=$LOOKUP_ELEMENT_RESULT")
  ATOMIC_MELT=$($PSQL "select melting_point_celsius from properties where atomic_number=$LOOKUP_ELEMENT_RESULT")
  ATOMIC_BOIL=$($PSQL "select boiling_point_celsius from properties where atomic_number=$LOOKUP_ELEMENT_RESULT")

  echo "The element with atomic number $ATOMIC_NUMBER is $ATOMIC_NAME ($ATOMIC_SYMBOL). It's a $ATOMIC_TYPE, with a mass of $ATOMIC_MASS amu. $ATOMIC_NAME has a melting point of $ATOMIC_MELT celsius and a boiling point of $ATOMIC_BOIL celsius."
fi
