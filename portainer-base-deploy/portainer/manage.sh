#!/bin/bash

# Portainer Management Script
# This script provides common management operations for Portainer

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display usage
show_usage() {
    echo "🐳 Portainer Management Script"
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start     Start Portainer containers"
    echo "  stop      Stop Portainer containers"
    echo "  restart   Restart Portainer containers"
    echo "  status    Show status of Portainer containers"
    echo "  logs      Show Portainer logs"
    echo "  update    Update Portainer to the latest version"
    echo "  backup    Create backup of Portainer data"
    echo "  restore   Restore Portainer data from backup"
    echo "  clean     Remove Portainer containers and volumes (DESTRUCTIVE)"
    echo "  help      Show this help message"
}

# Function to check if docker compose is available
get_compose_cmd() {
    if command -v docker-compose &> /dev/null; then
        echo "docker-compose"
    elif docker compose version &> /dev/null; then
        echo "docker compose"
    else
        echo -e "${RED}❌ Docker Compose is not available${NC}"
        exit 1
    fi
}

# Function to start Portainer
start_portainer() {
    echo -e "${YELLOW}🚀 Starting Portainer...${NC}"
    COMPOSE_CMD=$(get_compose_cmd)
    $COMPOSE_CMD up -d
    echo -e "${GREEN}✅ Portainer started${NC}"
}

# Function to stop Portainer
stop_portainer() {
    echo -e "${YELLOW}🛑 Stopping Portainer...${NC}"
    COMPOSE_CMD=$(get_compose_cmd)
    $COMPOSE_CMD down
    echo -e "${GREEN}✅ Portainer stopped${NC}"
}

# Function to restart Portainer
restart_portainer() {
    echo -e "${YELLOW}🔄 Restarting Portainer...${NC}"
    stop_portainer
    start_portainer
}

# Function to show status
show_status() {
    echo -e "${BLUE}📊 Portainer Status:${NC}"
    COMPOSE_CMD=$(get_compose_cmd)
    $COMPOSE_CMD ps
}

# Function to show logs
show_logs() {
    echo -e "${BLUE}📋 Portainer Logs:${NC}"
    COMPOSE_CMD=$(get_compose_cmd)
    $COMPOSE_CMD logs -f portainer
}

# Function to update Portainer
update_portainer() {
    echo -e "${YELLOW}⬆️ Updating Portainer...${NC}"
    COMPOSE_CMD=$(get_compose_cmd)
    $COMPOSE_CMD pull
    $COMPOSE_CMD up -d
    echo -e "${GREEN}✅ Portainer updated${NC}"
}

# Function to backup Portainer data
backup_portainer() {
    echo -e "${YELLOW}💾 Creating Portainer backup...${NC}"
    BACKUP_DIR="backups"
    BACKUP_FILE="portainer-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
    
    mkdir -p $BACKUP_DIR
    
    # Create backup of the portainer data volume
    docker run --rm -v portainer_portainer_data:/data -v $(pwd)/$BACKUP_DIR:/backup alpine tar czf /backup/$BACKUP_FILE -C /data .
    
    echo -e "${GREEN}✅ Backup created: $BACKUP_DIR/$BACKUP_FILE${NC}"
}

# Function to restore Portainer data
restore_portainer() {
    echo -e "${YELLOW}📥 Restoring Portainer data...${NC}"
    
    if [ -z "$2" ]; then
        echo -e "${RED}❌ Please specify backup file path${NC}"
        echo "Usage: $0 restore <backup-file>"
        exit 1
    fi
    
    BACKUP_FILE="$2"
    
    if [ ! -f "$BACKUP_FILE" ]; then
        echo -e "${RED}❌ Backup file not found: $BACKUP_FILE${NC}"
        exit 1
    fi
    
    # Stop Portainer before restore
    stop_portainer
    
    # Restore backup
    docker run --rm -v portainer_portainer_data:/data -v $(pwd):/backup alpine sh -c "cd /data && tar xzf /backup/$BACKUP_FILE"
    
    # Start Portainer
    start_portainer
    
    echo -e "${GREEN}✅ Portainer data restored from: $BACKUP_FILE${NC}"
}

# Function to clean Portainer (DESTRUCTIVE)
clean_portainer() {
    echo -e "${RED}⚠️ WARNING: This will remove all Portainer containers, volumes, and data!${NC}"
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}🧹 Cleaning Portainer...${NC}"
        COMPOSE_CMD=$(get_compose_cmd)
        $COMPOSE_CMD down -v --remove-orphans
        docker volume rm portainer_portainer_data 2>/dev/null || true
        echo -e "${GREEN}✅ Portainer cleaned${NC}"
    else
        echo -e "${YELLOW}Operation cancelled${NC}"
    fi
}

# Main script logic
case "${1:-help}" in
    start)
        start_portainer
        ;;
    stop)
        stop_portainer
        ;;
    restart)
        restart_portainer
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs
        ;;
    update)
        update_portainer
        ;;
    backup)
        backup_portainer
        ;;
    restore)
        restore_portainer "$@"
        ;;
    clean)
        clean_portainer
        ;;
    help|*)
        show_usage
        ;;
esac
