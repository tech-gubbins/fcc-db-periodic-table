#!/bin/bash

# A bash script for looking up elements on the periodic table, 
# which is referenced by a PSQL database.

# Connect to database
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

# Get user input from arg 1
USER_INPUT=$1

# Check if any input given
if [[ -z $USER_INPUT ]]; then
  # Error to user, if no argument provided
  echo -e "Please provide an element as an argument."
else
  # Check if input is numeric (for atomic_number) or a string (for symbol or name)
  if [[ $USER_INPUT =~ ^[0-9]+$ ]]
  then
    # Query database using atomic_number and user input
    FIND_ELEMENT_RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number = $USER_INPUT")
  else 
    FIND_ELEMENT_RESULT=$($PSQL "SELECT * FROM elements WHERE symbol = '$USER_INPUT' OR name = '$USER_INPUT'")
  fi

  # Check if input matches atomic_number, symbol, or name from database
  if [[ -z $FIND_ELEMENT_RESULT ]]
  then
    # If not found, error to user and exit
    echo -e "\nI could not find that element in the database.\n"
  else
    # If found, print information to user
    echo "Element found"
  fi
fi
