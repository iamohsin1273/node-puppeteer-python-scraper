# STAGE 1: Node.js Scraper
FROM node:18-slim AS scraper

# Tell Puppeteer NOT to download its own Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Install Chromium and required system libs
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-liberation \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxrandr2 \
    libgbm1 \
    libgtk-3-0 \
    libnss3 \
    libxshmfence1 \
    libasound2 \
    libx11-xcb1 \
    libdrm2 \
    libxdamage1 \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json .
RUN npm install

COPY scrape.js .

# Tell Puppeteer where Chromium is
ENV CHROME_PATH=/usr/bin/chromium

# Accept website URL
ARG SCRAPE_URL=https://example.com
ENV SCRAPE_URL=$SCRAPE_URL

# Run the scraper
RUN node scrape.js


# STAGE 2: Python Server
FROM python:3.10-slim

WORKDIR /app

# Copy only JSON output from scraper stage
COPY --from=scraper /app/scraped_data.json .
COPY server.py .
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["python", "server.py"]

