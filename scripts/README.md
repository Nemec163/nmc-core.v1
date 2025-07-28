# NMC Scripts Documentation

Набор скриптов для управления NMC проектом на VPS сервере.

## Обзор скриптов

### 🐳 docker-manager.sh
Основной скрипт для управления Docker контейнерами через docker-compose.

**Основные команды:**
```bash
./scripts/docker-manager.sh start           # Запустить все сервисы
./scripts/docker-manager.sh stop            # Остановить все сервисы
./scripts/docker-manager.sh restart         # Перезапустить все сервисы
./scripts/docker-manager.sh build           # Собрать все образы
./scripts/docker-manager.sh rebuild [service] # Пересобрать конкретный сервис
./scripts/docker-manager.sh deploy          # Полное развертывание
./scripts/docker-manager.sh status          # Показать статус
./scripts/docker-manager.sh health          # Проверить здоровье сервисов
./scripts/docker-manager.sh logs [service]  # Показать логи
./scripts/docker-manager.sh clean           # Очистить Docker ресурсы
```

**Примеры:**
```bash
# Запустить только nmc-site
./scripts/docker-manager.sh start nmc-site

# Пересобрать nmc-server с нуля
./scripts/docker-manager.sh rebuild nmc-server

# Следить за логами nmc-storybook
./scripts/docker-manager.sh logs nmc-storybook --follow

# Принудительная пересборка всех образов
./scripts/docker-manager.sh build --force
```

### 🛠️ dev-helper.sh
Вспомогательный скрипт для управления зависимостями и workspace'ами (можно использовать локально для подготовки).

**Основные команды:**
```bash
./scripts/dev-helper.sh install             # Установить зависимости
./scripts/dev-helper.sh build               # Собрать все пакеты
./scripts/dev-helper.sh lint                # Проверить код
./scripts/dev-helper.sh clean               # Очистить node_modules и dist
./scripts/dev-helper.sh workspaces          # Показать workspace'ы
```

### ⚡ nmc.sh
Быстрые команды и алиасы для удобства.

**Использование:**
```bash
# Выполнить команду напрямую
./scripts/nmc.sh quick-start    # Запуск + проверка здоровья
./scripts/nmc.sh full-restart   # Полный перезапуск
./scripts/nmc.sh fresh          # Чистая установка + пересборка

# Или настроить алиасы (добавить в ~/.bashrc или ~/.zshrc)
source /path/to/nmc-core.v1/scripts/nmc.sh
```

**Доступные алиасы после source:**
```bash
nmc-start           # docker-manager start
nmc-stop            # docker-manager stop
nmc-restart         # docker-manager restart
nmc-build           # docker-manager build
nmc-status          # docker-manager status
nmc-logs            # docker-manager logs
nmc-deploy          # docker-manager deploy
nmc-clean           # docker-manager clean
```

## Типичные сценарии использования

### 🚀 Первоначальное развертывание
```bash
# 1. Клонируем репозиторий
git clone <repo-url> nmc-core.v1
cd nmc-core.v1

# 2. Делаем скрипты исполняемыми
chmod +x scripts/*.sh

# 3. Полное развертывание
./scripts/docker-manager.sh deploy
```

### 🔄 Обновление после изменений в коде
```bash
# Быстрое обновление (если изменился только код)
./scripts/docker-manager.sh rebuild nmc-site

# Или полное обновление всех сервисов
./scripts/docker-manager.sh build --force
./scripts/docker-manager.sh restart
```

### 📊 Мониторинг и диагностика
```bash
# Проверить статус всех сервисов
./scripts/docker-manager.sh status

# Проверить здоровье сервисов
./scripts/docker-manager.sh health

# Посмотреть логи
./scripts/docker-manager.sh logs nmc-server --follow
```

### 🧹 Очистка и обслуживание
```bash
# Очистить неиспользуемые Docker ресурсы
./scripts/docker-manager.sh clean

# Полная очистка и пересборка
./scripts/docker-manager.sh stop
./scripts/docker-manager.sh clean
./scripts/docker-manager.sh build --force
./scripts/docker-manager.sh start
```

## Настройка алиасов для удобства

Добавьте в ваш `~/.bashrc` или `~/.zshrc`:

```bash
# NMC Project Aliases
if [ -f /path/to/nmc-core.v1/scripts/nmc.sh ]; then
    source /path/to/nmc-core.v1/scripts/nmc.sh
fi
```

После этого можно использовать короткие команды:
```bash
nmc-quick-start     # Быстрый запуск
nmc-status          # Статус
nmc-logs nmc-site   # Логи сайта
```

## Логирование

Все операции docker-manager.sh логируются в `logs/docker-manager.log`. 

Для просмотра логов:
```bash
tail -f logs/docker-manager.log
```

## Сервисы

- **nmc-site** - Frontend (Next.js)
- **nmc-server** - Backend API (NestJS)
- **nmc-storybook** - Storybook для UI компонентов
- **nginx** - Reverse proxy и статические файлы

## Порты

- **80/443** - nginx (HTTP/HTTPS)
- **3000** - nmc-site (внутренний)
- **3001** - nmc-server (внутренний)

## Требования

- Docker и Docker Compose
- Bash 4.0+
- curl/wget для health checks

## Устранение неполадок

### Сервис не запускается
```bash
# Проверить логи
./scripts/docker-manager.sh logs [service-name]

# Проверить статус
./scripts/docker-manager.sh status

# Пересобрать сервис
./scripts/docker-manager.sh rebuild [service-name]
```

### Проблемы с Docker
```bash
# Очистить все Docker ресурсы
./scripts/docker-manager.sh clean

# Проверить доступное место
docker system df

# Перезапустить Docker daemon (если нужно)
sudo systemctl restart docker
```

### Проблемы с nginx
```bash
# Проверить конфигурацию nginx
docker exec nmc-nginx nginx -t

# Перезагрузить nginx
docker exec nmc-nginx nginx -s reload
```
