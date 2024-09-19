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
    FIND_ELEMENT_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $USER_INPUT")
  else 
    FIND_ELEMENT_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$USER_INPUT' OR name = '$USER_INPUT'")
  fi

  # Check if input matches atomic_number, symbol, or name from database
  if [[ -z $FIND_ELEMENT_RESULT ]]
  then
    # If not found, error to user and exit
    echo -e "I could not find that element in the database."
  else
    # If found, query for element name and symbol, and read the results into variables
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number = $FIND_ELEMENT_RESULT")
    IFS="|" read ATOMIC_NUMBER SYMBOL NAME <<< "$ELEMENT"

    # Query for the element's properties, and read the results into variables
    PROPERTIES=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number = $FIND_ELEMENT_RESULT")
    IFS="|" read ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE_ID <<< "$PROPERTIES"

    # Query for the element's type
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")

    # Print result to user
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
fi
