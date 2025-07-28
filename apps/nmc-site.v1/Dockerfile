FROM node:20-alpine AS base
RUN corepack enable && corepack prepare pnpm@latest --activate

FROM base AS deps
WORKDIR /app
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/nmc-site.v1/package.json ./apps/nmc-site.v1/package.json
RUN pnpm install --frozen-lockfile --filter nmc-site.v1 || (rm -rf node_modules && pnpm install --filter nmc-site.v1)

FROM base AS build
WORKDIR /app
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/nmc-site.v1/package.json ./apps/nmc-site.v1/package.json
RUN pnpm install --frozen-lockfile --filter nmc-site.v1 || (rm -rf node_modules && pnpm install --filter nmc-site.v1)
COPY . .
RUN pnpm --filter nmc-site.v1 build

FROM base AS runtime
WORKDIR /app
RUN apk add --no-cache curl
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy package files first
COPY --from=build --chown=nextjs:nodejs /app/package.json ./package.json
COPY --from=build --chown=nextjs:nodejs /app/apps/nmc-site.v1/package.json ./apps/nmc-site.v1/package.json

# Copy dependencies
COPY --from=deps --chown=nextjs:nodejs /app/node_modules ./node_modules
COPY --from=deps --chown=nextjs:nodejs /app/apps/nmc-site.v1/node_modules ./apps/nmc-site.v1/node_modules

# Copy built application
COPY --from=build --chown=nextjs:nodejs /app/apps/nmc-site.v1/.next ./apps/nmc-site.v1/.next
COPY --from=build --chown=nextjs:nodejs /app/apps/nmc-site.v1/public ./apps/nmc-site.v1/public

WORKDIR /app/apps/nmc-site.v1
USER nextjs
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000 || exit 1

CMD ["pnpm", "start"]
