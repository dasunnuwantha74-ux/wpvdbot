FROM node:18-bullseye

# Install Chrome and other dependencies
RUN apt-get update && apt-get install -y \
    chromium \
    chromium-sandbox \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgdk-pixbuf2.0-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    wget \
    ffmpeg \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Set Chromium path
ENV CHROME_BIN=/usr/bin/chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

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
