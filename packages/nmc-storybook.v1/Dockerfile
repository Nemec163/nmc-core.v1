# Dockerfile for Storybook - Build only
FROM node:22-alpine AS builder

# Install pnpm
RUN corepack enable && corepack use pnpm@10.8.1

# Set working directory
WORKDIR /app

# Copy workspace configuration
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml turbo.json tsconfig.base.json ./

# Copy package manifests
COPY apps/nmc-server.v1/package.json ./apps/nmc-server.v1/
COPY apps/nmc-site.v1/package.json ./apps/nmc-site.v1/
COPY packages/nmc-ui.v1/package.json ./packages/nmc-ui.v1/
COPY packages/nmc-storybook.v1/package.json ./packages/nmc-storybook.v1/

# Copy source code
COPY . .

# Install dependencies
RUN pnpm install --no-frozen-lockfile

# Build dependencies first (ui package)
RUN pnpm --filter nmc-ui.v1 build

# Build Storybook
WORKDIR /app/packages/nmc-storybook.v1
RUN pnpm build

# Export stage - lightweight alpine with built files
FROM alpine:latest AS export
RUN apk add --no-cache rsync
COPY --from=builder /app/packages/nmc-storybook.v1/storybook-static /storybook-static
WORKDIR /
CMD ["sh"]
