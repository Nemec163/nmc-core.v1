FROM node:20-alpine

WORKDIR /app

COPY . .

RUN corepack enable && corepack prepare pnpm@latest --activate

RUN rm -rf dist-storybook && pnpm install && pnpm build-storybook

RUN pnpm add -g serve

EXPOSE 6006

CMD ["serve", "-s", "dist-storybook", "-l", "6006"]