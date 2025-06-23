# Puppeteer

A Node.js library for controlling Chrome/Chromium over the DevTools Protocol.

## Features
- Browser automation
- Web scraping
- Screenshot generation
- PDF generation
- Performance testing
- Web testing
- Headless browser control

## Quick Start
1. Start Puppeteer:
   ```bash
   docker-compose up -d
   ```
2. Access the API at [http://localhost:4057](http://localhost:4057)
3. Use the API for browser automation

## Configuration
- App code: `./app`
- Screenshots: `./screenshots`
- PDFs: `./pdfs`

## Environment Variables
- `PUPPETEER_SKIP_CHROMIUM_DOWNLOAD`: Skip Chromium download
- `PUPPETEER_EXECUTABLE_PATH`: Chromium executable path
- `NODE_ENV`: Node environment

## Ports
- API: 4057
- Chrome: 4444 (Selenium)
- Chrome VNC: 7900 (for debugging)

## Use Cases
- **Web Scraping**: Extract data from websites
- **Screenshots**: Generate website screenshots
- **PDF Generation**: Convert web pages to PDF
- **Testing**: Automated browser testing
- **Performance**: Page load time analysis
- **Automation**: Form filling, clicking, navigation

## API Endpoints
- `POST /screenshot`: Take screenshot of URL
- `POST /pdf`: Generate PDF from URL
- `POST /scrape`: Extract data from URL
- `GET /health`: Health check

## Example Usage
```bash
# Take screenshot
curl -X POST http://localhost:4057/screenshot \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}'

# Generate PDF
curl -X POST http://localhost:4057/pdf \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}'
```

## Chrome Debugging
- Access Chrome VNC at [http://localhost:7900](http://localhost:7900)
- Password: `secret`
- Useful for debugging automation scripts

## Docs
- [Official Documentation](https://pptr.dev/)
- [GitHub](https://github.com/puppeteer/puppeteer)
- [API Reference](https://pptr.dev/api/)

## Tips
- Use for automated testing
- Handle dynamic content
- Optimize for performance
- Handle errors gracefully
- Use headless mode for production 