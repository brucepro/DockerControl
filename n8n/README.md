# n8n

Workflow automation tool that helps you automate tasks across different services.

## Features
- Visual workflow editor
- 200+ integrations
- Self-hosted automation
- Webhook support
- Custom nodes
- Execution history
- Team collaboration

## Quick Start
1. Start n8n:
   ```bash
   docker-compose up -d
   ```
2. Access the web UI at [http://localhost:5678](http://localhost:5678)
3. Create your first workflow

## Configuration
- Data: `./data`
- Database: `./db`

## Environment Variables
- `N8N_BASIC_AUTH_ACTIVE`: Enable basic auth
- `N8N_BASIC_AUTH_USER`: Username
- `N8N_BASIC_AUTH_PASSWORD`: Password
- `N8N_ENCRYPTION_KEY`: Encryption key
- `DB_TYPE`: Database type (sqlite/postgres)
- `DB_POSTGRESDB_HOST`: PostgreSQL host
- `DB_POSTGRESDB_DATABASE`: Database name
- `DB_POSTGRESDB_USER`: Database user
- `DB_POSTGRESDB_PASSWORD`: Database password

## Ports
- Web UI: 5678

## Workflow Examples
- Email automation
- Social media posting
- Data synchronization
- File processing
- API integrations
- Notification systems

## Popular Integrations
- Slack, Discord, Teams
- Gmail, Outlook
- GitHub, GitLab
- Google Sheets, Airtable
- Twitter, LinkedIn
- Webhooks, APIs

## Docs
- [Official Documentation](https://docs.n8n.io/)
- [GitHub](https://github.com/n8n-io/n8n)
- [Community](https://community.n8n.io/)
- [Workflow Templates](https://n8n.io/workflows)

## Tips
- Start with simple workflows
- Use webhooks for real-time triggers
- Test workflows before production
- Use environment variables for secrets
- Regular backups of workflows
- Monitor execution history 