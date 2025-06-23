# Mealie - Recipe Management System

Mealie is a self-hosted recipe manager and meal planner that allows you to organize, search, and plan your meals.

## Features

- **Recipe Management**: Store and organize your favorite recipes
- **Meal Planning**: Plan your meals for the week or month
- **Shopping Lists**: Generate shopping lists from meal plans
- **Recipe Import**: Import recipes from various websites
- **Nutrition Information**: Track nutritional information
- **Multi-User Support**: Share recipes with family members
- **Mobile Friendly**: Responsive design for mobile devices
- **API Access**: RESTful API for integration with other services

## Services

### mealie (Main Interface)
- **Purpose**: Primary web interface for recipe management
- **Port**: 9000
- **URL**: http://localhost:9000
- **Features**: Full recipe management, meal planning, shopping lists

### mealie-api (API Interface)
- **Purpose**: API endpoint for external integrations
- **Port**: 9001
- **URL**: http://localhost:9001
- **Features**: RESTful API access, same data as main interface

## Quick Start

1. **Start the service**:
   ```bash
   docker-compose up -d
   ```

2. **Access the web interface**:
   - Main Interface: http://localhost:9000
   - API Interface: http://localhost:9001

3. **Initial setup**:
   - Default credentials: `admin@example.com` / `MyPassword123`
   - Change default password on first login
   - Configure your preferences

## Directory Structure

```
mealie/
├── docker-compose.yml
├── README.md
├── data/          # Application data and database
├── recipes/       # Recipe files and images
└── backups/       # Backup files
```

## Configuration

### Environment Variables
- `TZ`: Timezone (default: UTC)
- `PUID`: User ID (default: 1000)
- `PGID`: Group ID (default: 1000)
- `WEB_PORT`: Web interface port (default: 9000)
- `BASE_URL`: Base URL for the application
- `DB_ENGINE`: Database engine (sqlite, postgresql)
- `DEFAULT_GROUP`: Default user group
- `DEFAULT_EMAIL`: Default admin email
- `DEFAULT_PASSWORD`: Default admin password
- `TOKEN_TIME`: Token expiration time in hours
- `DISABLE_SIGNUP`: Disable user registration
- `DISABLE_ANALYTICS`: Disable analytics tracking

### Volumes
- `./data`: Application data and database
- `./recipes`: Recipe files and images
- `./backups`: Backup files

### Ports
- `9000`: Main web interface
- `9001`: API interface

## Usage Examples

### Basic Usage
```bash
# Start all services
docker-compose up -d

# Start only main interface
docker-compose up -d mealie

# Start only API interface
docker-compose up -d mealie-api

# Stop services
docker-compose down
```

### Recipe Management
```bash
# Access web interface
open http://localhost:9000

# Add recipes manually
# Use the web interface to create new recipes

# Import recipes from URLs
# Use the import feature in the web interface
```

### API Usage
```bash
# Access API documentation
open http://localhost:9001/docs

# Get all recipes
curl http://localhost:9001/api/recipes

# Get specific recipe
curl http://localhost:9001/api/recipes/1
```

## Recipe Import

### Supported Sources
- **URL Import**: Import recipes from various cooking websites
- **Manual Entry**: Create recipes manually through the interface
- **File Upload**: Upload recipe files in various formats
- **API Integration**: Use the API to add recipes programmatically

### Import Process
1. Go to the recipe creation page
2. Choose import method (URL, manual, file)
3. Fill in recipe details
4. Add ingredients and instructions
5. Save the recipe

## Meal Planning

### Planning Features
- **Weekly Planning**: Plan meals for the entire week
- **Monthly Planning**: Long-term meal planning
- **Recipe Suggestions**: Get recipe suggestions based on available ingredients
- **Shopping Lists**: Generate shopping lists from meal plans

### Planning Process
1. Access the meal planning interface
2. Select dates for planning
3. Add recipes to specific days
4. Generate shopping list
5. Export or share plans

## Shopping Lists

### List Generation
- **Automatic Generation**: Create lists from meal plans
- **Manual Creation**: Create lists manually
- **Ingredient Aggregation**: Combine ingredients from multiple recipes
- **Category Organization**: Organize items by category

### List Management
- **Mark Items**: Mark items as purchased
- **Add Notes**: Add notes to items
- **Share Lists**: Share lists with family members
- **Export Lists**: Export lists in various formats

## User Management

### User Roles
- **Admin**: Full access to all features
- **User**: Can create and manage own recipes
- **Guest**: Read-only access to public recipes

### User Features
- **Personal Recipes**: Users can create private recipes
- **Shared Recipes**: Share recipes with other users
- **Personal Settings**: Customize personal preferences
- **Profile Management**: Manage user profiles

## Backup and Migration

### Backup
```bash
# Backup application data
tar -czf mealie-backup-$(date +%Y%m%d).tar.gz data/

# Backup recipes
tar -czf mealie-recipes-$(date +%Y%m%d).tar.gz recipes/
```

### Migration
```bash
# Copy existing Mealie data
cp -r /path/to/existing/data data/

# Copy recipes
cp -r /path/to/existing/recipes recipes/

# Restart services
docker-compose restart
```

## Performance Optimization

### Storage
- Use SSD storage for better performance
- Regular cleanup of temporary files
- Optimize image storage

### Memory
- Monitor memory usage with large recipe collections
- Consider increasing container memory limits
- Use image optimization

### Database
- Regular database maintenance
- Consider using PostgreSQL for large deployments
- Backup database regularly

## Troubleshooting

### Common Issues

1. **Permission errors**:
   ```bash
   # Fix directory permissions
   sudo chown -R 1000:1000 data/ recipes/ backups/
   ```

2. **Port conflicts**:
   - Change port mappings in docker-compose.yml
   - Check if ports are already in use

3. **Database issues**:
   ```bash
   # Backup and recreate database
   cp data/app.db data/app.db.backup
   rm data/app.db
   docker-compose restart
   ```

4. **Import failures**:
   - Check internet connectivity
   - Verify recipe URL is accessible
   - Check import format compatibility

### Logs
```bash
# View main service logs
docker-compose logs -f mealie

# View API service logs
docker-compose logs -f mealie-api
```

## Security Considerations

- **Change Default Passwords**: Update admin password immediately
- **Network Security**: Use reverse proxy with SSL/TLS
- **Access Control**: Limit access to trusted networks
- **Regular Updates**: Keep Mealie images updated
- **Backup Strategy**: Regular backups of data and recipes

## Integration

### Reverse Proxy (Nginx)
```nginx
location /mealie {
    proxy_pass http://localhost:9000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

### External Access
```bash
# Configure for external access
# Update docker-compose.yml with proper network settings
# Use reverse proxy for security
```

## API Documentation

### Authentication
```bash
# Login to get token
curl -X POST http://localhost:9001/api/auth/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=admin@example.com&password=MyPassword123"
```

### Recipe Endpoints
```bash
# Get all recipes
curl http://localhost:9001/api/recipes

# Get specific recipe
curl http://localhost:9001/api/recipes/1

# Create new recipe
curl -X POST http://localhost:9001/api/recipes \
  -H "Content-Type: application/json" \
  -d '{"name": "New Recipe", "description": "A delicious recipe"}'
```

## Resources

- **Mealie Official**: https://docs.mealie.io/
- **GitHub**: https://github.com/hay-kot/mealie
- **Docker Hub**: https://hub.docker.com/r/hkotel/mealie
- **Documentation**: https://docs.mealie.io/

## License

Mealie is open-source software licensed under the MIT License. 