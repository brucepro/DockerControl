# Gitea

A lightweight, self-hosted Git service similar to GitHub, GitLab, or Bitbucket.

## Features
- Git repository hosting
- Web-based UI
- Issue tracking, pull requests, wiki
- SSH and HTTP(S) access
- Webhooks and API
- CI/CD integration
- LDAP/SSO support

## Quick Start
1. Start Gitea:
   ```bash
   docker-compose up -d
   ```
2. Access the web UI at [http://localhost:4026](http://localhost:4026)
3. Register your user and create your first repo

## Data
- App data: `./data`
- Database: `./db`

## Docs
- [Official Documentation](https://docs.gitea.com/)
- [GitHub](https://github.com/go-gitea/gitea)

## Port
- Web UI: 4026
- SSH: 222 