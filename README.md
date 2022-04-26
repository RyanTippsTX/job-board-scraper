# Job Board Scraper
Scrape job posting statistics by keyword &amp; location.
Currently only supports Indeed.com job board.

# How To Use
1. Open your terminal and clone this repo to your machine  
```git clone https://github.com/RyanTippsTX/job-board-scraper.git```  
2. Navigate into the new directory  
```cd job-board-scraper/```  
3. Open the shell script ```job-board-scraper.sh``` and customize the list of search terms and locations at the top of the file, then save and close the file.  
```open job-board-scraper.sh```  
4. Run the script with Z-shell 
```zsh job-board-scraper.sh```  
<img width="652" alt="image" src="https://user-images.githubusercontent.com/89077432/163337787-5512878a-c719-418b-9db4-135655c1f010.png">  

# Notes On Usage
- Remember if a job posting mentions your keyword at all, it will count towards the total. So if you see 1,000 Python jobs in your city, some of those are Python developer jobs but some could be Java jobs that also mention Python, or snake handler jobs that mention Python.
- A posting date filter of "last 14 days" is applied for all queries. The default on Indeed's website does not filter by posting date. 
- A 50 mile search radius is applied for all queries (except for "Remote"). The default on Indeed's website is only 25.
- You can manually verify queries results and see the actual job postings at https://www.indeed.com/ .

# Issues
- One known bug (see issue #4 ). Occasionally the script will fail to scrape data for certain queries. Usually re-running the script once or twice will fix the issue. 
