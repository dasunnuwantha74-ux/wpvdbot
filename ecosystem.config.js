module.exports = {
  apps: [
    {
      name: 'wpvdbot',
      script: './bot.js',
      instances: 1,
      exec_mode: 'fork',
      watch: false,
      max_memory_restart: '500M',
      merge_logs: true,
      autorestart: true,
      max_restarts: 10,
      min_uptime: '10s',
      env: {
        NODE_ENV: 'production',
        CHROME_BIN: '/usr/bin/chromium-browser',
        PUPPETEER_SKIP_CHROMIUM_DOWNLOAD: 'true'
      },
      error_file: './logs/err.log',
      out_file: './logs/out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z'
    }
  ]
};
