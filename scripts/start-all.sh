#!/bin/bash

echo "🚀 Запуск всех сервисов..."

docker start nmc-site nmc-server nmc-ui

echo "✅ Все контейнеры запущены."
