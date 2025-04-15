
# Используем node только для сборки
FROM node:20-alpine AS builder

WORKDIR /app

COPY . .

RUN corepack enable && corepack prepare pnpm@latest --activate

RUN rm -rf dist-storybook \
  && pnpm install --frozen-lockfile \
  && pnpm build-storybook

# Используем nginx для быстрой раздачи статики
FROM nginx:stable-alpine

COPY --from=builder /app/dist-storybook /usr/share/nginx/html

# Убираем лишние дефолтные конфиги
RUN rm /etc/nginx/conf.d/default.conf

# Наш минималистичный конфиг
COPY nginx.conf /etc/nginx/conf.d/storybook.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]