FROM node:20-alpine

WORKDIR /app

COPY ../../ ./

RUN corepack enable && corepack prepare pnpm@latest --activate

RUN rm -rf packages/nmc-ui.v1/dist-storybook \
  && pnpm install \
  && cd packages/nmc-ui.v1 && pnpm build-storybook --output-dir dist-storybook

RUN pnpm add -g serve

WORKDIR /app/packages/nmc-ui.v1

EXPOSE 6006

CMD ["serve", "-s", "dist-storybook", "-l", "6006"]
