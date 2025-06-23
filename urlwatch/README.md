# urlwatch

A tool for monitoring webpages for changes.

## Features
- Website change monitoring
- Email notifications
- RSS feed monitoring
- Custom filters
- Diff highlighting
- Scheduled monitoring
- Multiple output formats

## Quick Start
1. Start urlwatch:
   ```bash
   docker-compose up -d
   ```
2. Configure URLs to monitor in `./config/urls.yaml`
3. Set up notification settings

## Configuration
- Config: `./config`
- URLs: `./config/urls.yaml`
- Settings: `./config/urlwatch.yaml`
- Hooks: `./config/hooks.py`

## Environment Variables
- `URLWATCH_CONFIG_DIR`: Configuration directory
- `URLWATCH_MAIL_SMTP`: SMTP server
- `URLWATCH_MAIL_FROM`: From email
- `URLWATCH_MAIL_TO`: To email

## Monitoring Setup
1. Edit `./config/urls.yaml`:
   ```yaml
   name: Example Site
   url: https://example.com
   filter: css:.content
   ```

2. Configure notifications in `./config/urlwatch.yaml`

3. Run monitoring:
   ```bash
   docker-compose exec urlwatch urlwatch
   ```

## Use Cases
- **Price Monitoring**: Track product prices
- **News Monitoring**: Watch for new articles
- **Status Pages**: Monitor service status
- **Job Listings**: Track new job postings
- **Documentation**: Watch for updates
- **Social Media**: Monitor social feeds

## Notification Methods
- Email notifications
- Push notifications
- Webhook calls
- Custom scripts
- Slack/Discord integration

## Docs
- [Official Documentation](https://urlwatch.readthedocs.io/)
- [GitHub](https://github.com/thp/urlwatch)
- [Configuration Guide](https://urlwatch.readthedocs.io/en/latest/config.html)

## Tips
- Use CSS selectors for specific content
- Set appropriate check intervals
- Configure email notifications
- Use filters to reduce false positives
- Monitor multiple URLs
- Set up logging for debugging 