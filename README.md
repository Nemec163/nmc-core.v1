# NMC Core v1

Монорепозиторий NMC проекта с микросервисной архитектурой.

## Структура проекта

```
nmc-core.v1/
├── apps/                    # Приложения
│   ├── nmc-site.v1/        # Frontend (Next.js)
│   └── nmc-server.v1/      # Backend API (NestJS)
├── packages/                # Пакеты
│   ├── nmc-ui.v1/          # UI компоненты
│   └── nmc-storybook.v1/   # Storybook
├── scripts/                 # Скрипты управления
└── services/               # Сервисы (nginx)
```

## 🚀 Быстрый старт для VPS

```bash
# Клонируем и переходим в проект
git clone <repo-url> nmc-core.v1
cd nmc-core.v1

# Делаем скрипты исполняемыми
chmod +x scripts/*.sh

# Полное развертывание
./scripts/docker-manager.sh deploy
```

## 📋 Управление проектом

### Основные команды

```bash
# Запуск/остановка сервисов
./scripts/docker-manager.sh start    # Запустить все
./scripts/docker-manager.sh stop     # Остановить все
./scripts/docker-manager.sh restart  # Перезапустить все

# Сборка и обновление
./scripts/docker-manager.sh build           # Пересобрать образы
./scripts/docker-manager.sh rebuild [svc]   # Пересобрать конкретный сервис
./scripts/docker-manager.sh deploy          # Полное развертывание

# Мониторинг
./scripts/docker-manager.sh status          # Статус сервисов
./scripts/docker-manager.sh health          # Проверка здоровья
./scripts/docker-manager.sh logs [service]  # Просмотр логов
```

### Удобные алиасы

Для удобства можно настроить алиасы:

```bash
# Добавить в ~/.bashrc или ~/.zshrc
source /path/to/nmc-core.v1/scripts/nmc.sh

# Теперь доступны короткие команды:
nmc-start        # Запуск
nmc-stop         # Остановка
nmc-status       # Статус
nmc-deploy       # Развертывание
```

## 🛠️ Разработка

### Локальная разработка

```bash
# Установка зависимостей
pnpm install

# Запуск dev серверов
pnpm run dev                # Все сервисы
pnpm run dev:site          # Только сайт
pnpm run dev:server        # Только сервер
pnpm run dev:storybook     # Только Storybook
```

### Сборка

```bash
pnpm run build              # Собрать все
pnpm run build:storybook    # Собрать Storybook
```

## 🐳 Docker сервисы

- **nmc-site** - Frontend приложение (Next.js)
- **nmc-server** - Backend API (NestJS)  
- **nmc-storybook** - Документация UI компонентов
- **nginx** - Reverse proxy и статические файлы

## 📚 Документация

- [Подробная документация скриптов](scripts/README.md)
- [Быстрый старт для VPS](scripts/QUICK_START.md)

## 🔧 Требования

- **Для VPS**: Docker, Docker Compose
- **Для локальной разработки**: Node.js, pnpm

## 📈 Мониторинг

```bash
# Проверить статус всех сервисов
./scripts/docker-manager.sh status

# Следить за логами
./scripts/docker-manager.sh logs --follow

# Проверить здоровье сервисов
./scripts/docker-manager.sh health
```

## 🧹 Обслуживание

```bash
# Очистить неиспользуемые Docker ресурсы
./scripts/docker-manager.sh clean

# Полная переустановка
./scripts/nmc.sh fresh
```

## 🚦 Порты

- **80/443** - nginx (HTTP/HTTPS)
- **3000** - nmc-site (внутренний)
- **3001** - nmc-server (внутренний)

---

Для получения помощи по любому скрипту используйте флаг `help`:

```bash
./scripts/docker-manager.sh help
./scripts/dev-helper.sh help
./scripts/nmc.sh help
```
