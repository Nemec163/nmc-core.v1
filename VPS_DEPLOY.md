# Simple VPS Deployment Guide

This guide provides a **minimal, working setup** for deploying NMC Core v1 on a VPS without complex build processes or "best practice" overhead.

## ✅ What's Fixed

- **Docker build failures** - Removed complex caching and SSL issues
- **Network timeouts** - Eliminated slow npm/pnpm installs during build
- **SSL certificate errors** - Simple HTTP-only setup
- **Container restart loops** - Simplified configuration

## 🚀 Quick Start (VPS Ready)

### 1. Prerequisites
- Docker and Docker Compose installed
- Basic VPS with root/sudo access

### 2. Deploy
```bash
# Clone the repository
git clone https://github.com/Nemec163/nmc-core.v1.git
cd nmc-core.v1

# Start everything with one command
./simple-deploy.sh start
```

### 3. Access Your Site
- **Main site**: http://your-vps-ip/
- **Storybook**: http://your-vps-ip/ui/
- **API**: http://your-vps-ip/api/
- **Health check**: http://your-vps-ip/health

## 📋 Management Commands

```bash
# Basic operations
./simple-deploy.sh start         # Start all services
./simple-deploy.sh stop          # Stop all services  
./simple-deploy.sh restart       # Restart all services
./simple-deploy.sh status        # Show current status

# Troubleshooting
./simple-deploy.sh logs          # Show all logs
./simple-deploy.sh logs nginx    # Show specific service logs
./simple-deploy.sh fresh         # Fresh deployment (rebuild)
```

## 🛠️ Architecture

This simplified setup uses:
- **nginx** - Reverse proxy and static content (port 80)
- **nmc-server** - Simple Express.js API server (port 3001)
- **nmc-site** - Static content served by nginx (port 80)
- **nmc-storybook** - UI components static site (port 80)

## 🔧 Customization

### Add SSL Later (Optional)
To add SSL certificates later:
1. Obtain SSL certificates (Let's Encrypt recommended)
2. Update `services/nginx/conf.d/default.conf`
3. Add certificate volumes to docker-compose.yml
4. Restart: `./simple-deploy.sh restart`

### Update Content
- Edit files in `static-content/` directory
- Restart: `./simple-deploy.sh restart`

### Monitor Logs
```bash
# Watch all logs in real-time
./simple-deploy.sh logs

# Watch specific service
./simple-deploy.sh logs nginx
```

## 🔍 Troubleshooting

### Services Won't Start
```bash
# Check status
./simple-deploy.sh status

# Check logs
./simple-deploy.sh logs

# Fresh restart
./simple-deploy.sh fresh
```

### Port Already in Use
```bash
# Stop everything
./simple-deploy.sh stop

# Check what's using port 80
sudo netstat -tulpn | grep :80

# Start again
./simple-deploy.sh start
```

### Container Keeps Restarting
```bash
# Check specific container logs
./simple-deploy.sh logs [service-name]

# Common fix: fresh deployment
./simple-deploy.sh fresh
```

## 📊 Resource Usage

This minimal setup uses:
- **CPU**: ~100-200MB per container
- **RAM**: ~50-100MB per container  
- **Disk**: ~200MB total
- **Network**: Standard HTTP (port 80)

Perfect for small VPS instances (1GB RAM, 1 CPU core).

## 🎯 Development vs Production

This is a **simple working setup** - not a production-ready configuration with all best practices. It's designed to:
- ✅ Work reliably on VPS
- ✅ Easy to deploy and manage
- ✅ Minimal resource usage
- ✅ Simple troubleshooting

For production, consider adding:
- SSL certificates
- Monitoring
- Backup strategies
- Security hardening
- Load balancing

## 💡 Tips

1. **Keep it simple** - This setup prioritizes working over complexity
2. **Monitor logs** - Use `./simple-deploy.sh logs` regularly
3. **Fresh deploys** - When in doubt, use `./simple-deploy.sh fresh`
4. **Resource monitoring** - Use `docker stats` to monitor usage
5. **Regular updates** - Pull latest changes and restart when needed