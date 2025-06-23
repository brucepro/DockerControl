# Website Change Monitoring with urlwatch

This Docker Compose setup provides comprehensive website change monitoring using urlwatch, a powerful tool for detecting changes on web pages.

## Features

- **Real-time monitoring**: Check websites at configurable intervals
- **Multiple notification channels**: Email, Slack, Discord, Telegram
- **Visual change detection**: Screenshot comparison for JavaScript-heavy sites
- **Web interface**: View monitoring status and history
- **Flexible filtering**: CSS selectors, XPath, JSON parsing
- **Data persistence**: SQLite database for historical data

## Quick Start

1. **Clone or download the configuration files**
2. **Edit the URLs to monitor** in `urlwatch-config/urls.yaml`
3. **Configure notifications** in `urlwatch-config/urlwatch.yaml`
4. **Start the services**:

```bash
# Basic monitoring
docker-compose -f docker-compose-urlwatch.yml up urlwatch

# Full stack with screenshots and notifications
docker-compose -f docker-compose-urlwatch.yml up -d
```

## Services

### 1. urlwatch (Port 8080)
- Main monitoring service
- Web interface at `http://localhost:8080`
- Handles URL checking and change detection

### 2. website-monitor (Port 8081)
- Alternative monitoring service
- Simplified configuration
- Good for basic monitoring needs

### 3. screenshot-service (Ports 4444, 7900)
- Selenium Chrome for JavaScript rendering
- VNC access at `http://localhost:7900` (no password)
- Enables visual change detection

### 4. notification-service (Port 3000)
- Custom notification handling
- Supports multiple channels
- Extensible notification logic

## Configuration

### URLs Configuration (`urlwatch-config/urls.yaml`)

Add websites to monitor:

```yaml
- name: "My Website"
  url: "https://example.com"
  filter: "css:.main-content"
  diff_filter: "html2text"
  max_age: 3600  # Check every hour
```

### Main Configuration (`urlwatch-config/urlwatch.yaml`)

Configure notifications and settings:

```yaml
email:
  enabled: true
  smtp:
    host: smtp.gmail.com
    user: your-email@gmail.com
    password: your-app-password
    to: recipient@example.com
```

### Custom Hooks (`urlwatch-config/hooks.py`)

Add custom processing logic:

```python
def process_urlwatch_report(job, job_state, urlwatch_config, report):
    if report.changed:
        # Custom notification logic
        send_custom_notification(job, report)
```

## Usage Examples

### Monitor a News Website
```yaml
- name: "Tech News"
  url: "https://techcrunch.com"
  filter: "css:.post-block__content"
  diff_filter: "html2text"
  max_age: 1800  # Check every 30 minutes
```

### Monitor Product Prices
```yaml
- name: "Amazon Product"
  url: "https://amazon.com/product/123"
  filter: "css:.a-price-whole"
  diff_filter: "html2text"
  max_age: 900  # Check every 15 minutes
```

### Monitor API Status
```yaml
- name: "API Health"
  url: "https://api.example.com/health"
  filter: "json"
  max_age: 300  # Check every 5 minutes
```

### Monitor JavaScript-heavy Sites
```yaml
- name: "SPA Application"
  url: "https://spa.example.com"
  filter: "css:.dynamic-content"
  screenshot: true  # Enable visual comparison
  max_age: 3600
```

## Notification Channels

### Email
Configure SMTP settings in `urlwatch.yaml`:
```yaml
email:
  enabled: true
  smtp:
    host: smtp.gmail.com
    port: 587
    user: your-email@gmail.com
    password: your-app-password
```

### Slack
```yaml
slack:
  enabled: true
  webhook_url: https://hooks.slack.com/services/YOUR/WEBHOOK/URL
```

### Discord
```yaml
discord:
  enabled: true
  webhook_url: https://discord.com/api/webhooks/YOUR/WEBHOOK/URL
```

### Telegram
```yaml
telegram:
  enabled: true
  bot_token: YOUR_BOT_TOKEN
  chat_id: YOUR_CHAT_ID
```

## Advanced Features

### Screenshot Comparison
Enable visual change detection for JavaScript-heavy sites:

1. Start the screenshot service
2. Add `screenshot: true` to your URL configuration
3. Access VNC at `http://localhost:7900` to debug

### Custom Filters
Use CSS selectors, XPath, or JSON filters:

```yaml
# CSS selector
filter: "css:.price, .title"

# XPath
filter: "xpath://div[@class='content']"

# JSON
filter: "json:$.data.items[*].title"
```

### Rate Limiting
Configure check intervals to avoid overwhelming servers:

```yaml
monitoring:
  check_interval: 300  # 5 minutes
  max_age: 3600       # 1 hour
```

## Security Considerations

1. **Change default passwords** in configuration files
2. **Use environment variables** for sensitive data
3. **Limit network access** to monitoring services
4. **Regular updates** of Docker images
5. **Monitor logs** for suspicious activity

## Troubleshooting

### Common Issues

1. **Permission errors**: Check file permissions on mounted volumes
2. **Network timeouts**: Increase timeout values in configuration
3. **False positives**: Adjust filters and diff settings
4. **Notification failures**: Verify webhook URLs and credentials

### Logs
View logs for debugging:
```bash
docker-compose -f docker-compose-urlwatch.yml logs urlwatch
```

### Database
Access the SQLite database:
```bash
docker-compose -f docker-compose-urlwatch.yml exec urlwatch sqlite3 /data/urlwatch.db
```

## Maintenance

### Regular Tasks
- Update Docker images: `docker-compose -f docker-compose-urlwatch.yml pull`
- Clean old cache: `docker-compose -f docker-compose-urlwatch.yml exec urlwatch urlwatch --clean-cache`
- Backup database: Copy `/data/urlwatch.db` to safe location

### Monitoring the Monitor
- Check service health: `docker-compose -f docker-compose-urlwatch.yml ps`
- Monitor resource usage: `docker stats`
- Review logs regularly for errors

## Support

- [urlwatch Documentation](https://urlwatch.readthedocs.io/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Issue Reporting](https://github.com/thp/urlwatch/issues) 