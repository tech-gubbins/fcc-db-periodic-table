#!/bin/bash

# A bash script for looking up elements on the periodic table, 
# which is referenced by a PSQL database.

# Connect to database
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"