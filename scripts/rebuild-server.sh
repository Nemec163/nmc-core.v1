#!/bin/bash

cd ~/nmc-core.v1/apps/nmc-server.v1

echo "🔨 Сборка nmc-server..."
docker build -t nmc-server .

echo "🔁 Перезапуск nmc-server..."
docker stop nmc-server && docker rm nmc-server
docker run -d --name nmc-server -p 3001:3000 --restart unless-stopped nmc-server

echo "✅ Готово!"
