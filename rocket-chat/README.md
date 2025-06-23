# Rocket.Chat

A self-hosted team chat platform that enables real-time conversations between colleagues, with other companies or with your customers, across devices on web, desktop or mobile.

## Features
- Real-time messaging
- Video and audio conferencing
- File sharing
- Screen sharing
- Mobile apps (iOS/Android)
- Desktop apps (Windows/macOS/Linux)
- Web interface
- Team collaboration tools
- Custom integrations
- API for developers

## Quick Start
1. Start Rocket.Chat:
   ```bash
   docker-compose up -d
   ```
2. Wait for initialization (may take 2-3 minutes)
3. Access the web UI at [http://localhost:4009](http://localhost:4009)
4. Create your first admin account

## Configuration
- Uploads: `./uploads`
- Database: `./mongo`

## Environment Variables
- `NODE_ENV`: Production environment
- `MONGO_URL`: MongoDB connection string
- `MONGO_OPLOG_URL`: MongoDB oplog connection
- `ROOT_URL`: Public URL for the application
- `PORT`: Application port (default: 3000)

## Initial Setup
1. **First Launch**: Wait for MongoDB to initialize (2-3 minutes)
2. **Admin Account**: Create the first admin user
3. **Organization Info**: Set up your organization details
4. **Server Setup**: Configure server settings
5. **Users**: Invite team members

## Key Features

### **Communication**
- **Channels**: Public and private channels
- **Direct Messages**: Private conversations
- **Group Messages**: Multi-person private chats
- **Threads**: Organized conversations

### **Media & Sharing**
- **File Uploads**: Share documents and images
- **Screen Sharing**: Present during video calls
- **Voice Messages**: Send audio clips
- **Emojis & Reactions**: Express yourself

### **Collaboration**
- **Video Calls**: Built-in video conferencing
- **Audio Calls**: Voice-only conversations
- **Screen Sharing**: Share your screen
- **Whiteboard**: Collaborative drawing

### **Integrations**
- **Webhooks**: Connect external services
- **API**: Custom integrations
- **Apps**: Official and community apps
- **Bots**: Automated assistants

## Mobile & Desktop Apps

### **Mobile Apps**
- **iOS**: Available on App Store
- **Android**: Available on Google Play
- **Features**: Push notifications, offline support

### **Desktop Apps**
- **Windows**: Native Windows app
- **macOS**: Native macOS app
- **Linux**: Native Linux app
- **Features**: System notifications, file drag & drop

## Administration

### **User Management**
- Create and manage users
- Set user roles and permissions
- Bulk user operations
- User statistics

### **Channel Management**
- Create public and private channels
- Set channel permissions
- Archive channels
- Channel statistics

### **Security**
- Two-factor authentication
- LDAP/Active Directory integration
- SAML SSO
- OAuth providers

### **Backup & Restore**
- Database backups
- File uploads backup
- Automated backup scheduling
- Disaster recovery

## Customization

### **Themes**
- Custom CSS
- Brand colors
- Logo customization
- Custom fonts

### **Apps & Integrations**
- **GitHub**: Code notifications
- **Jira**: Issue tracking
- **Slack**: Import from Slack
- **Webhooks**: Custom integrations

## Performance Optimization

### **For N100 Mini PC**
- **Memory**: ~500MB RAM usage
- **CPU**: Moderate usage
- **Storage**: Depends on file uploads
- **Network**: Real-time connections

### **Scaling**
- Horizontal scaling with multiple instances
- Load balancing
- Database clustering
- CDN for file uploads

## Troubleshooting

### **Common Issues**
1. **Slow Startup**: MongoDB initialization takes time
2. **Connection Issues**: Check network and firewall
3. **File Uploads**: Ensure upload directory permissions
4. **Memory Usage**: Monitor MongoDB memory usage

### **Logs**
```bash
# View Rocket.Chat logs
docker-compose logs rocketchat

# View MongoDB logs
docker-compose logs mongo

# View all logs
docker-compose logs
```

## Docs
- [Official Documentation](https://docs.rocket.chat/)
- [GitHub](https://github.com/RocketChat/Rocket.Chat)
- [Community](https://community.rocket.chat/)
- [Apps Directory](https://rocket.chat/marketplace)

## Tips
- Use strong passwords for admin accounts
- Regular database backups
- Monitor resource usage
- Keep Rocket.Chat updated
- Use SSL/TLS in production
- Configure proper user permissions
- Set up automated backups

## Port
- Web UI: 4009 