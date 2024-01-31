#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
  then 
    echo -e 'Please provide an element as an argument.'
    exit
fi

#if arg atomic_num
if [[ $1 =~ ^[1-9]+$ ]]
  then 
    element_data=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number = '$1'")
   else
   #if arg is name / symbol
    element_data=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where symbol = '$1' or name = '$1'")
fi 
 
 #check if data available
if [[ -z $element_data ]]
 then
   echo "I could not find that element in the database."
   exit
fi

#show data
echo $element_data | while IFS=" |" read AT_NUM NAME SYMBOL TYPE MASS MELT_P BOIL_P 
  do
    echo "The element with atomic number $AT_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_P celsius and a boiling point of $BOIL_P celsius."
  done
