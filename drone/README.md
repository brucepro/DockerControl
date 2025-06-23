# Drone CI

A self-hosted continuous integration and delivery platform built on container technology.

## Features
- Container-based CI/CD pipelines
- GitHub, GitLab, Gitea, Bitbucket integration
- Scalable runners
- Secrets management
- Web UI and API

## Quick Start
1. Set your GitHub/Gitea credentials and secrets in `docker-compose.yml`
2. Start Drone:
   ```bash
   docker-compose up -d
   ```
3. Access the web UI at [http://localhost:4027](http://localhost:4027)

## Data
- App data: `./data`

## Docs
- [Official Documentation](https://docs.drone.io/)
- [GitHub](https://github.com/harness/drone)

## Port
- Web UI: 4027 