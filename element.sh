PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

INPUT_VALUE=$1

main(){
  if [[ -z "$INPUT_VALUE" ]]
    then
      echo "Please provide an element as an argument."
    else
      if [[ $INPUT_VALUE =~ ^[0-9]+$ ]]
        then
          ELEMENTS_RESULT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number = $INPUT_VALUE")
            if [[ -z $ELEMENTS_RESULT ]]
              then
                echo "I could not find that element in the database."
              else
                IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME <<< "$ELEMENTS_RESULT"
                PROPERTIES_RESULT=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
                IFS='|' read -r ATOMIC_MASS MPC BPC TI <<< "$PROPERTIES_RESULT"
                TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TI")
                echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
            fi
        else
          LENGTH=${#INPUT_VALUE}
            if [[ $LENGTH > 2 ]]
              then
                ELEMENTS_RESULT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE name = '$INPUT_VALUE'")
                if [[ -z $ELEMENTS_RESULT ]]
                  then
                    echo "I could not find that element in the database."
                  else
                    IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME <<< "$ELEMENTS_RESULT"
                    PROPERTIES_RESULT=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
                    IFS='|' read -r ATOMIC_MASS MPC BPC TI <<< "$PROPERTIES_RESULT"
                    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TI")
                    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
                  fi
              else
                ELEMENTS_RESULT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE symbol = '$INPUT_VALUE'")
                if [[ -z $ELEMENTS_RESULT ]]
                  then
                    echo "I could not find that element in the database."
                  else
                    IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME <<< "$ELEMENTS_RESULT"
                    PROPERTIES_RESULT=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
                    IFS='|' read -r ATOMIC_MASS MPC BPC TI <<< "$PROPERTIES_RESULT"
                    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TI")
                    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
                  fi
            fi
      fi
  fi
}

main
