FROM node:20-alpine

WORKDIR /repo

COPY . .

RUN corepack enable && corepack prepare pnpm@latest --activate
RUN pnpm install --frozen-lockfile

WORKDIR /repo/packages/nmc-ui.v1

RUN pnpm build-storybook
RUN pnpm add -g serve

EXPOSE 6006
CMD ["serve", "-s", "dist-storybook", "-l", "6006"]
