# Portainer Deployment

A complete Docker-based Portainer deployment with SSL support, backup functionality, and management scripts.

## 🚀 Quick Start

1. **Clone or download this project**
2. **Run the deployment script:**

   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

3. **Access Portainer:**
   - HTTP: <http://localhost:9000>
   - HTTPS: <https://localhost:9443>

## 📋 Prerequisites

- Docker (version 20.10 or higher)
- Docker Compose (v2.0 or higher) or docker-compose (v1.29 or higher)
- OpenSSL (for SSL certificate generation)

## 🔧 Configuration

### Environment Variables

Copy `.env.example` to `.env` and customize the following variables:

```bash
# Portainer Configuration
PORTAINER_ADMIN_PASSWORD=          # Initial admin password (optional)
PORTAINER_EDGE_KEY=               # Edge key for Edge Agent (optional)
PORTAINER_LOGO_URL=               # Custom logo URL (optional)

# SSL Configuration
SSL_ENABLED=true                  # Enable/disable SSL
SSL_CERT_PATH=/data/portainer.crt # SSL certificate path
SSL_KEY_PATH=/data/portainer.key  # SSL private key path

# Network Configuration
PORTAINER_HTTP_PORT=9000          # HTTP port
PORTAINER_HTTPS_PORT=9443         # HTTPS port
PORTAINER_AGENT_PORT=9001         # Agent port (for remote Docker hosts)

# Docker Configuration
DOCKER_HOST=unix:///var/run/docker.sock  # Docker socket path

# Backup Configuration
BACKUP_ENABLED=false              # Enable automatic backups
BACKUP_SCHEDULE="0 2 * * *"       # Backup schedule (cron format)
BACKUP_RETENTION_DAYS=30          # Backup retention period

# Logging Configuration
LOG_LEVEL=INFO                    # Log level (DEBUG, INFO, WARN, ERROR)
LOG_FILE_ENABLED=false            # Enable log file output
```

### Docker Compose Services

The deployment includes:

- **Portainer CE**: Main container management interface
- **Portainer Agent** (optional): For managing remote Docker hosts
- **Persistent volumes**: For data persistence
- **SSL/TLS encryption**: For secure access

## 🛠️ Management

Use the management script for common operations:

```bash
chmod +x manage.sh

# Available commands:
./manage.sh start     # Start Portainer containers
./manage.sh stop      # Stop Portainer containers
./manage.sh restart   # Restart Portainer containers
./manage.sh status    # Show container status
./manage.sh logs      # Show Portainer logs
./manage.sh update    # Update to latest version
./manage.sh backup    # Create data backup
./manage.sh restore <backup-file>  # Restore from backup
./manage.sh clean     # Remove all containers and data (DESTRUCTIVE)
./manage.sh help      # Show help message
```

## 🔐 SSL Certificates

### Self-Signed Certificates (Default)

The deployment script automatically generates self-signed SSL certificates. Your browser will show a security warning, which you can safely bypass for local development.

### Custom SSL Certificates

To use your own SSL certificates:

1. Place your certificate files in the `ssl/` directory:
   - `ssl/portainer.crt` (certificate file)
   - `ssl/portainer.key` (private key file)

2. Update the docker-compose.yml if needed to mount the certificates correctly.

### Let's Encrypt Certificates

For production deployments with Let's Encrypt:

1. Install Certbot
2. Generate certificates for your domain
3. Update the volume mounts in docker-compose.yml to point to your Let's Encrypt certificates

## 💾 Backup and Restore

### Manual Backup

```bash
./manage.sh backup
```

Backups are stored in the `backups/` directory with timestamps.

### Restore from Backup

```bash
./manage.sh restore backups/portainer-backup-YYYYMMDD-HHMMSS.tar.gz
```

### Automated Backups

Set up automated backups using cron:

```bash
# Add to crontab (crontab -e)
0 2 * * * /path/to/portainer/manage.sh backup
```

## 🌐 Remote Docker Management

To manage remote Docker hosts, uncomment the Portainer Agent service in `docker-compose.yml` and deploy it on your remote Docker hosts.

### On Remote Hosts

```bash
docker run -d \
  -p 9001:9001 \
  --name portainer_agent \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  portainer/agent:latest
```

### In Portainer UI

1. Go to "Environments"
2. Add new environment
3. Select "Docker via Agent"
4. Enter the remote host IP and port 9001

## 🔍 Troubleshooting

### Common Issues

1. **Port already in use**

   ```bash
   # Check what's using the port
   sudo netstat -tulpn | grep :9000
   
   # Change ports in .env file
   PORTAINER_HTTP_PORT=9010
   PORTAINER_HTTPS_PORT=9453
   ```

2. **Permission denied on Docker socket**

   ```bash
   # Add user to docker group
   sudo usermod -aG docker $USER
   
   # Log out and back in, or run:
   newgrp docker
   ```

3. **SSL certificate issues**

   ```bash
   # Regenerate certificates
   rm ssl/portainer.*
   ./deploy.sh
   ```

4. **Container won't start**

   ```bash
   # Check logs
   ./manage.sh logs
   
   # Check container status
   docker ps -a
   ```

### Logs and Debugging

```bash
# View Portainer logs
./manage.sh logs

# View all container logs
docker-compose logs

# Debug mode
docker-compose up --no-daemon
```

## 📁 Project Structure

```text
portainer/
├── docker-compose.yml      # Main Docker Compose configuration
├── .env.example           # Environment variables template
├── deploy.sh             # Deployment script
├── manage.sh             # Management script
├── ssl/                  # SSL certificates directory
│   ├── portainer.crt    # SSL certificate (generated)
│   └── portainer.key    # SSL private key (generated)
├── backups/             # Backup files directory
└── README.md           # This file
```

## 🔗 Useful Links

- [Portainer Documentation](https://docs.portainer.io/)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

Feel free to submit issues and feature requests!

---

## Happy containerizing! 🐳
