# Graylog

A powerful log management platform for collecting, indexing, and analyzing log data.

## Features
- Centralized log collection
- Real-time search and analysis
- Dashboards and alerting
- User management and roles
- Integrates with Elasticsearch and MongoDB

## Quick Start
1. Start Graylog:
   ```bash
   docker-compose up -d
   ```
2. Access the web UI at [http://localhost:4040](http://localhost:4040)
3. Login with admin credentials (set in `docker-compose.yml`)

## Data
- App data: `./data`
- MongoDB: `./mongodb`
- Elasticsearch: `./elasticsearch`

## Docs
- [Official Documentation](https://docs.graylog.org/)
- [GitHub](https://github.com/Graylog2/graylog2-server)

## Port
- Web UI: 4040
- Syslog UDP: 12201
- Syslog TCP: 1514 