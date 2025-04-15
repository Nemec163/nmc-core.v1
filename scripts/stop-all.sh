#!/bin/bash

echo "⛔ Остановка всех сервисов..."

docker stop nmc-site nmc-server nmc-ui

echo "✅ Все контейнеры остановлены."
