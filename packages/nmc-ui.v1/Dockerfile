FROM node:20-alpine

WORKDIR /app

COPY . .

RUN corepack enable && corepack prepare pnpm@latest --activate

# Устанавливаем зависимости (в идеале должен быть --frozen-lockfile, если lock актуален)
RUN pnpm install --no-frozen-lockfile

# Сборка сторибука
RUN pnpm build-storybook

# Установка serve — простой HTTP-сервер
RUN pnpm add -g serve

EXPOSE 6006

# Запуск как статика
CMD ["serve", "-s", "dist-storybook", "-l", "6006"]
