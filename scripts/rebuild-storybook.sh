#!/bin/bash

# Script to rebuild Storybook static files

echo "🔧 Rebuilding Storybook..."

# Stop and remove existing builder container
docker-compose down nmc-storybook-builder 2>/dev/null || true

# Remove the image to force rebuild
docker rmi nmc-corev1_nmc-storybook 2>/dev/null || true

# Remove the volume to start fresh
docker volume rm nmc-corev1_storybook-static 2>/dev/null || true

# Build and run the builder
docker-compose up --build nmc-storybook-builder

# Restart nginx to pick up new files
docker-compose restart nmc-nginx

echo "✅ Storybook rebuild complete!"
echo "📚 Storybook should be available at: https://nemec.app/ui/"

# Show volume status
docker volume ls | grep storybook
