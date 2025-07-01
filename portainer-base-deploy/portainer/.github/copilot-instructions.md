<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Portainer Deployment Project Instructions

This is a Docker-based Portainer deployment project. When working with this codebase:

## Project Context
- This is a container management solution using Portainer CE
- The project uses Docker Compose for orchestration
- SSL/TLS encryption is configured by default with self-signed certificates
- Includes management scripts for common operations
- Supports backup and restore functionality

## Best Practices
- Follow Docker best practices for security and performance
- Use environment variables for configuration
- Maintain backward compatibility when updating configurations
- Include proper error handling in shell scripts
- Use semantic versioning for any custom components
- Document any changes to the deployment configuration

## Code Style
- Use consistent shell script formatting with proper error handling
- YAML files should be properly indented and validated
- Environment variables should be descriptive and well-documented
- Use meaningful names for volumes, networks, and services

## Security Considerations
- Always use least privilege principle for container permissions
- Keep SSL certificates secure and properly configured
- Regularly update base images and dependencies
- Use secrets management for sensitive configuration
- Implement proper backup encryption for production deployments
