# NMC VPS Quick Start

## Быстрое развертывание на VPS

```bash
# 1. Клонируем репозиторий
git clone <your-repo-url> nmc-core.v1
cd nmc-core.v1

# 2. Делаем скрипты исполняемыми
chmod +x scripts/*.sh

# 3. Настраиваем алиасы (опционально)
echo 'source /path/to/nmc-core.v1/scripts/nmc.sh' >> ~/.bashrc
source ~/.bashrc

# 4. Полное развертывание
./scripts/docker-manager.sh deploy
```

## Основные команды

```bash
# Управление сервисами
nmc-start          # Запуск всех сервисов
nmc-stop           # Остановка всех сервисов
nmc-restart        # Перезапуск всех сервисов
nmc-status         # Статус сервисов

# Сборка и обновление
nmc-build          # Пересборка образов
nmc-rebuild [svc]  # Пересборка конкретного сервиса
nmc-deploy         # Полное развертывание

# Мониторинг
nmc-logs [service] # Просмотр логов
nmc-health         # Проверка здоровья сервисов

# Обслуживание
nmc-clean          # Очистка Docker ресурсов
nmc-fresh          # Полная переустановка
```

## После обновления кода

```bash
# Обновить конкретный сервис
nmc-rebuild nmc-site

# Или обновить все
nmc-build --force && nmc-restart
```

Подробная документация: [scripts/README.md](README.md)
