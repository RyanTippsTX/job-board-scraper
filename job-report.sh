#!/bin/zsh

# Author : Ryan Tipps
# Copyright (c) 2022 Ryan Tipps

# source URL example:
# https://www.indeed.com/jobs?q=rails&l=remote&fromage=14

# returns number of postings for one location & one term
poll-Indeed-single () { 
  LOCATION=$(echo $1)
  KEYWORD=$(echo $2)
  curl -s "https://www.indeed.com/jobs?q=$KEYWORD&l=$LOCATION&fromage=14" | grep -E "[0-9]+ jobs</div>" | cut -d' ' -f 24
  # curl -s "https://www.indeed.com/jobs?q=React&l=Remote&fromage=14" | grep -E "[0-9]+ jobs</div>" | cut -d' ' -f 24
}

# MAIN REPORT
echo -e 'Indeed.com job postings in last 14 days by location and keyword mentions:\n'
echo -e "KEYWORD \tREMOTE \t\tAUSTIN"  
# locations wired in manually ...
declare -a LOCATIONS=(
  'Remote' 
  'Austin,TX&radius=50'
  )
declare -a SEARCH_TERMS=(
  'Rails' 
  'Django' 
  'Node'
  'Angular'
  'React'
  'Vue'
  )
for t in "${SEARCH_TERMS[@]}"
do
   echo -e "$t\t\t$( poll-Indeed-single 'Remote' $t )\t\t$( poll-Indeed-single 'Austin,TX&radius=50' $t )" &
done
wait


# curl -s "https://www.indeed.com/jobs?q=React&l=Remote&fromage=14" | grep -E "[0-9]+ jobs</div>" | cut -d' ' -f 24