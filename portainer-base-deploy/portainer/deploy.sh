#!/bin/bash

# Portainer Deployment Script
# This script helps you deploy Portainer with SSL certificates

set -e

echo "🐳 Portainer Deployment Setup"
echo "============================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Docker is not running. Please start Docker first.${NC}"
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not available. Please install Docker Compose.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker is ready${NC}"

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo -e "${YELLOW}📝 Creating .env file from template...${NC}"
    cp .env.example .env
    echo -e "${GREEN}✅ .env file created. Please edit it with your configuration.${NC}"
fi

# Create SSL certificates directory
mkdir -p ssl

# Generate self-signed SSL certificates if they don't exist
if [ ! -f ssl/portainer.crt ] || [ ! -f ssl/portainer.key ]; then
    echo -e "${YELLOW}🔐 Generating self-signed SSL certificates...${NC}"
    
    # Generate private key
    openssl genrsa -out ssl/portainer.key 2048
    
    # Generate certificate signing request
    openssl req -new -key ssl/portainer.key -out ssl/portainer.csr -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
    
    # Generate self-signed certificate
    openssl x509 -req -days 365 -in ssl/portainer.csr -signkey ssl/portainer.key -out ssl/portainer.crt
    
    # Clean up CSR file
    rm ssl/portainer.csr
    
    echo -e "${GREEN}✅ SSL certificates generated${NC}"
else
    echo -e "${GREEN}✅ SSL certificates already exist${NC}"
fi

# Set proper permissions for SSL files
chmod 600 ssl/portainer.key
chmod 644 ssl/portainer.crt

echo -e "${YELLOW}🚀 Starting Portainer...${NC}"

# Use docker-compose or docker compose based on availability
if command -v docker-compose &> /dev/null; then
    docker-compose up -d
else
    docker compose up -d
fi

echo -e "${GREEN}✅ Portainer deployment completed!${NC}"
echo ""
echo "🌐 Access Portainer at:"
echo "  HTTP:  http://localhost:9000"
echo "  HTTPS: https://localhost:9443"
echo ""
echo "📋 Next steps:"
echo "  1. Open your browser and navigate to https://localhost:9443"
echo "  2. Create your admin account"
echo "  3. Connect to your local Docker environment"
echo ""
echo "⚠️  Note: Since we're using self-signed certificates, your browser will show a security warning."
echo "   You can safely proceed by clicking 'Advanced' and 'Proceed to localhost'."
