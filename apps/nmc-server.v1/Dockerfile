FROM node:20-alpine AS base
RUN corepack enable && corepack prepare pnpm@latest --activate

FROM base AS deps
WORKDIR /app
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/nmc-server.v1/package.json ./apps/nmc-server.v1/package.json
RUN pnpm install --frozen-lockfile --filter nmc-server.v1

FROM base AS build
WORKDIR /app
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/nmc-server.v1/package.json ./apps/nmc-server.v1/package.json
RUN pnpm install --frozen-lockfile --filter nmc-server.v1
COPY . .
RUN pnpm --filter nmc-server.v1 build

FROM base AS runtime
WORKDIR /app
RUN apk add --no-cache curl
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nestjs

COPY --from=deps --chown=nestjs:nodejs /app/node_modules ./node_modules
COPY --from=deps --chown=nestjs:nodejs /app/apps/nmc-server.v1/node_modules ./apps/nmc-server.v1/node_modules
COPY --from=build --chown=nestjs:nodejs /app/apps/nmc-server.v1/dist ./apps/nmc-server.v1/dist
COPY --from=build --chown=nestjs:nodejs /app/apps/nmc-server.v1/package.json ./apps/nmc-server.v1/package.json
COPY --from=build --chown=nestjs:nodejs /app/package.json ./package.json

WORKDIR /app/apps/nmc-server.v1
USER nestjs
EXPOSE 3001
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3001/health || exit 1

CMD ["pnpm", "start:prod"]
