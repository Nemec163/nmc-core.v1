#!/bin/bash

echo "🔁 Перезапуск всех сервисов..."

docker restart nmc-site nmc-server nmc-ui

echo "✅ Все контейнеры перезапущены!"
