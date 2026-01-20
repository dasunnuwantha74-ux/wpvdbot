FROM node:18-bullseye

# Install Chrome and other dependencies
RUN apt-get update && apt-get install -y \
    chromium-browser \
    ca-certificates \
    libgtk-3-0 \
    libnotify-dev \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2 \
    libappindicator1 \
    libindicator7 \
    xdg-utils \
    fonts-liberation \
    libappindicator3-1 \
    libcurl4 \
    wget \
    ffmpeg \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Set Chromium path
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Install PM2 globally
RUN npm install -g pm2

# Copy application files
COPY bot.js ./

# Create directories for auth and backups
RUN mkdir -p .wwebjs_auth backups logs videos

# Create PM2 ecosystem config
RUN echo '{ \
  "apps": [{ \
    "name": "wpvdbot", \
    "script": "bot.js", \
    "instances": 1, \
    "exec_mode": "fork", \
    "watch": false, \
    "max_memory_restart": "500M", \
    "merge_logs": true, \
    "autorestart": true, \
    "max_restarts": 10, \
    "min_uptime": "10s" \
  }] \
}' > ecosystem.config.js

# Expose port if needed (for QR code display)
EXPOSE 3000

# Start bot with PM2
CMD ["pm2-runtime", "start", "ecosystem.config.js"]
