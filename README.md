This project uses:
- Node.js + Puppeteer + Chromium to scrape websites
- Python + Flask to host the scraped data

## Build

docker build --build-arg SCRAPE_URL=https://example.com -t web-scraper .


## Run

docker run -p 5000:5000 web-scraper


## View Output

Open:

http://localhost:5000
