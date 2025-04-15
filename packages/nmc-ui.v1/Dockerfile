# ./packages/nmc-ui.v1/Dockerfile

FROM node:20-alpine

WORKDIR /app

# Копируем всё из корня монорепо
COPY ../../ ./

# Активируем pnpm и собираем Storybook
RUN corepack enable && corepack prepare pnpm@latest --activate

RUN cd packages/nmc-ui.v1 && pnpm build-storybook --output-dir dist-storybook

# Устанавливаем сервер
RUN pnpm add -g serve

# Рабочая директория — внутрь UI пакета
WORKDIR /app/packages/nmc-ui.v1

EXPOSE 6006

CMD ["serve", "-s", "dist-storybook", "-l", "6006"]
