# WordPress

The world's most popular content management system for building websites.

## Features
- Content management system
- Blog platform
- Website builder
- Plugin ecosystem
- Theme customization
- User management
- SEO tools

## Quick Start
1. Start WordPress:
   ```bash
   docker-compose up -d
   ```
2. Access the web UI at [http://localhost:4053](http://localhost:4053)
3. Complete the WordPress installation

## Configuration
- WordPress files: `./wordpress`
- Database: `./db`
- Uploads: `./wordpress/wp-content/uploads`

## Environment Variables
- `WORDPRESS_DB_HOST`: Database host
- `WORDPRESS_DB_NAME`: Database name
- `WORDPRESS_DB_USER`: Database user
- `WORDPRESS_DB_PASSWORD`: Database password
- `WORDPRESS_TABLE_PREFIX`: Table prefix

## Ports
- Web UI: 4053

## Initial Setup
1. Choose language
2. Create admin account
3. Set site title and description
4. Install themes and plugins
5. Configure settings

## Popular Plugins
- Yoast SEO
- Contact Form 7
- WooCommerce
- Elementor
- Jetpack
- Wordfence Security

## Popular Themes
- Twenty Twenty-Four
- Astra
- GeneratePress
- OceanWP
- Divi
- Avada

## Docs
- [Official Documentation](https://wordpress.org/support/)
- [Developer Documentation](https://developer.wordpress.org/)
- [Plugin Directory](https://wordpress.org/plugins/)
- [Theme Directory](https://wordpress.org/themes/)

## Tips
- Keep WordPress and plugins updated
- Use strong passwords
- Regular backups
- Optimize images
- Use caching plugins
- Enable SSL certificate 