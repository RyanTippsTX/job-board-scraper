#!/bin/zsh

# Author : Ryan Tipps
# License : MIT

scrape_Indeed () { 
  # Scrapes the reported number of matching job postings from an indivudual query on Indeed.com job board.

  # Build URL based on search parameters:
  # NOTE: Indeed URL-encodes spaces (%20) but NOT commas. This is non-standard. Therefore we have to manually URL-encode rather than using curl's built-in URL encoding.
  location=$1
  search_term=$2

  # testing='hello world'
  # echo ${testing//' '/'%20'}

  scrape_url="https://www.indeed.com/jobs"
  scrape_url+="?"
  scrape_url+="q=${search_term//' '/'%20'}"
  scrape_url+="&"
  scrape_url+="q=${location//' '/'%20'}"
  # if [ ${location,,} != 'remote' ] 
  # then
  #   scrape_url+="&"
  #   scrape_url+="radius=50"
  # fi
  scrape_url+="&"
  scrape_url+="fromage=14"
  # Typical resulting URL: https://www.indeed.com/jobs?q=Java&l=remote&fromage=14
  

  # Fetch page from Indeed and scrape the reported result:
  # This is very site specific and prone to breaking. Needs improvement!
  curl -s $scrape_url | grep -E "[0-9]+ jobs</div>" | cut -d' ' -f 24
}


run_report (){
  # Aggregates data and prints report to stdout

  echo -e 'Indeed.com job postings in last 14 days by location and keyword mentions:\n'
  echo -e "SEARCH TERM \tREMOTE \t\tAUSTIN"  

  # locations not are wired in manually for now... 
  # declare -a LOCATIONS=(
  #   'Remote' 
  #   'Austin,TX&radius=50'
  #   )

  declare -a search_terms=(
    'Rails' 
    'Django' 
    'Node'
    'Angular'
    'React'
    'Vue'
    )
  for t in "${search_terms[@]}"
  do
    echo -e "$t\t\t$( scrape_Indeed 'Remote' $t )\t\t$( scrape_Indeed 'Austin,TX&radius=50' $t )" &
  done
  wait
}

# Execute !!
# run_report

# ---------- DEBUG ----------

# This URL works. "Austin,TX" has no spaces, but interestingly does have a comma.
scrape_url='https://www.indeed.com/jobs?q=Java&l=Austin,TX&radius=50'

# These URLs do not work in curl, but DOES work in the browser. When entered into the 
# browser, it appears to redirect and oddly encodes the comma but not the space. 
# scrape_url='https://www.indeed.com/jobs?q=Java&l=Austin, TX&radius=50'
# scrape_url='https://www.indeed.com/jobs?q=Java&l=San Antonio, TX&radius=50'

curl -s $scrape_url
