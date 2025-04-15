#!/bin/bash

echo "🧹 Очистка остановленных контейнеров и ненужных образов..."
docker container prune -f
docker image prune -f
docker volume prune -f
echo "✅ Docker очищен!"
