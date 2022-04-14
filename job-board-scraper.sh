#!/bin/zsh

# Author : Ryan Tipps
# License : MIT

normalize_string () {
  # removes spaces, commas, periods, and apostrophies from input string, replaces with
  # I created this to avoid using the non-portable sed command

  # remove_characters=(' ' , . \')
  replace_with='-'
  A=${1// /$replace_with}
  B=${A//,}
  C=${B//./$replace_with}
  D=${C//\'/$replace_with}
  echo $D
}

scrape_Indeed () { 
  # Scrapes the reported number of matching job postings from an indivudual query on Indeed.com job board.

  # Build URL based on search parameters:
  # NOTE: Indeed URL-encodes spaces (%20) but NOT commas. This is non-standard. Therefore we have to 
  # manually URL-encode rather than using curl's built-in URL encoding.
  location=$1
  radius=50 # leave hard coded for now
  search_term=$2
  from_age=14 # leave hard coded for now
  scrape_url="https://www.indeed.com/jobs"
  scrape_url+="?"
  scrape_url+="q=${search_term//' '/%20}"
  scrape_url+='&'
  scrape_url+="l=${location//' '/%20}"
  if [ $location:l != 'remote' ] 
  then
    scrape_url+="&"
    scrape_url+="radius=$radius"
  fi  
  scrape_url+="&"
  scrape_url+="fromage=$from_age"
  # echo $scrape_url
  # Typical resulting URL: https://www.indeed.com/jobs?q=Java&l=remote&fromage=14

  # Fetch page from Indeed and scrape the reported result:
  # This scrape is very site-specific to Indeed.com and prone to breaking. Needs improvement!
  # echo $scrape_url
  curl -s $scrape_url | grep -E "[0-9]+ jobs</div>" | cut -d' ' -f 24
}


run_report (){
  # Aggregates data and prints report to stdout

  # locations not are wired in manually for now... 
  declare -a locations=(
    'Remote' 
    'Austin, TX'
  )

  declare -a search_terms=(
    # 'Java'
    # 'Spring' 
    # 'PHP'
    # 'Laravel'
    # 'Rails' 
    # 'Django' 
    # 'Flask' 
    # 'Node'
    'Angular'
    'React'
    # 'Vue'
  )

  # Scrape the data asynchronously
  declare -A data
  for T in "${search_terms[@]}"
  do
    for L in "${locations[@]}"
    do
      index="L-$(normalize_string $L)-T-$(normalize_string $T)"
      data+=([$index]="L-$(normalize_string $L)-T-$(normalize_string $T)")
    done
  done
  # wait

  # Print output:
  printf "%s\n" 'Indeed.com job postings in last 14 days by location and keyword mentions:'
  printf "%s\n"
  (
    # Print column headers
    printf "\n%s" "SEARCH TERM" 
    for L in "${locations[@]}"
    do
      printf '_'
      printf $L:u
    done
    printf "%s\n"

    # Print data rows
    for T in "${search_terms[@]}"
    do
      printf $T
      for L in "${locations[@]}"
      do
        printf '_'
        index="L-$(normalize_string $L)-T-$(normalize_string $T)"
        printf "${data[$index]}"
      done
      printf "%s\n"
    done

  ) | column -t -s '_'
}

# Execute !!
run_report
