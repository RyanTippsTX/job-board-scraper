# job-board-scraper
Scrape job posting statistics by keyword &amp; location

# Status
Work in progress.
The script is only partially working as of commit bbdfd5a - I am unsure how to properly encode spaces and commas in the URL in a way that works with Indeed's servers and with curl. As long as there are no spaces in the location or search terms the script will function properly (e.g. "Austin,TX" works but "Austin, TX" and "San Francisco, CA" do not).
