#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [ -z "$1" ]
then
  echo "Please provide an element as an argument."
else
  if [[ "$1" =~ ^-?[0-9]+$ ]]
  then
    # CHECK_ATOMIC
    CHECK_ATOMIC=$($PSQL "select count(*) from elements where atomic_number=$1;")
    if [[ $CHECK_ATOMIC -gt 0 ]]
    then
      RESULT=$($PSQL "select atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius from types full join properties using (type_id) full join elements using(atomic_number) where atomic_number=$1;")
      
      # Process the result: we expect the result to be a single row with values
      # e.g., 1 | Hydrogen | H | 1.008 | -259.1 | -252.9
      IFS='|' read -r atomic_number name symbol atomic_mass melting_point_celsius boiling_point_celsius <<< "$RESULT"

      # Clean up the values (strip leading/trailing spaces)
      ATOM=$(echo $atomic_number | xargs)
      name=$(echo $name | xargs)
      symbol=$(echo $symbol | xargs)
      atomic_mass=$(echo $atomic_mass | xargs)
      melting_point_celsius=$(echo $melting_point_celsius | xargs)
      boiling_point_celsius=$(echo $boiling_point_celsius | xargs)

      # Construct the sentence
      echo "The element with atomic number $atomic_number is $name ($symbol). It's a nonmetal, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
    else
      echo "I could not find that element in the database."
    fi
  else
    # CHECK_SYMBOL or CHECK_NAME
    CHECK_SYMBOL=$($PSQL "select count(*) from elements where name='$1' or symbol='$1';")
    if [[ $CHECK_SYMBOL -gt 0 ]]
    then
      RESULT=$($PSQL "select atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius from types full join properties using (type_id) full join elements using(atomic_number) where name ILIKE '$1' or symbol ILIKE '$1';")
      
      # Process the result: we expect the result to be a single row with values
      # e.g., 1 | Hydrogen | H | 1.008 | -259.1 | -252.9
      IFS='|' read -r atomic_number name symbol atomic_mass melting_point_celsius boiling_point_celsius <<< "$RESULT"

      # Clean up the values (strip leading/trailing spaces)
      ATOM=$(echo $atomic_number | xargs)
      name=$(echo $name | xargs)
      symbol=$(echo $symbol | xargs)
      atomic_mass=$(echo $atomic_mass | xargs)
      melting_point_celsius=$(echo $melting_point_celsius | xargs)
      boiling_point_celsius=$(echo $boiling_point_celsius | xargs)

      # Construct the sentence
      echo "The element with atomic number $atomic_number is $name ($symbol). It's a nonmetal, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
    else
      echo "I could not find that element in the database."
    fi
  fi
fi

