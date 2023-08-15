#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE teams, games RESTART IDENTITY")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
TEAM_ONE_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
TEAM_TWO_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
  if [[ -z $TEAM_ONE_NAME ]]
  then
    if [[ $WINNER != 'winner' ]]
    then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
    fi
  fi
  if [[ -z $TEAM_TWO_NAME ]]
  then
   if [[ $OPPONENT != 'opponent' ]]
    then   
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
    fi
  fi
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  echo $WINNER_ID
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ $YEAR != "year" ]]
  then
    echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")"
  fi
  
done
