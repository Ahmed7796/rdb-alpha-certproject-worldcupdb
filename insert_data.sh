#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=wc_test -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Truncate the tables at each run:
echo $($PSQL "TRUNCATE teams, games RESTART IDENTITY")
# Insert data into the teams table first:
# Read after the first line, read 3rd and 4th arguments, sort uniquely, and read names:
tail -n +2 games.csv | awk -F, '{print $3; print $4}' | sort -u | while read -r name;
do
# Add teams to the teams table:
echo $($PSQL "INSERT INTO teams(name) VALUES('$name')")
done

# For the games table:
tail -n +2 games.csv | while IFS=',' read -r year round winner opponent winner_goals opponent_goals;
do
# Get Winner ID:
winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
# GetOpponent ID:
opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
# Insert into games table:
echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)")

done