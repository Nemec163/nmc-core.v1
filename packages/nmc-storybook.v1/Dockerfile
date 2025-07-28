# syntax=docker/dockerfile:1.7-labs
# Multi-stage build for Storybook with optimized caching

# Import shared base
FROM ../../docker/Dockerfile.base AS base

# Dependencies stage with cache mount
FROM deps-base AS deps
# Copy package manifests for optimal layer caching
COPY packages/nmc-storybook.v1/package.json ./packages/nmc-storybook.v1/
COPY packages/nmc-ui.v1/package.json ./packages/nmc-ui.v1/

# Install dependencies with cache mount for pnpm store
RUN --mount=type=cache,target=/pnpm-cache,uid=1001,gid=1001 \
    --mount=type=cache,target=/app/node_modules/.pnpm,uid=1001,gid=1001 \
    pnpm install --frozen-lockfile --filter nmc-storybook.v1...

# Build stage
FROM build-base AS build
# Copy dependencies from deps stage
COPY --from=deps --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --from=deps --chown=appuser:appgroup /app/packages/nmc-storybook.v1/node_modules ./packages/nmc-storybook.v1/node_modules
COPY --from=deps --chown=appuser:appgroup /app/packages/nmc-ui.v1/node_modules ./packages/nmc-ui.v1/node_modules

# Copy source files for build
COPY --chown=appuser:appgroup packages/nmc-ui.v1/ ./packages/nmc-ui.v1/
COPY --chown=appuser:appgroup packages/nmc-storybook.v1/ ./packages/nmc-storybook.v1/

# Switch to app user for build
USER appuser

# Build UI package first
RUN --mount=type=cache,target=/app/.turbo,uid=1001,gid=1001 \
    pnpm --filter nmc-ui.v1 build

# Build Storybook with cache mount
WORKDIR /app/packages/nmc-storybook.v1
RUN --mount=type=cache,target=/app/.turbo,uid=1001,gid=1001 \
    --mount=type=cache,target=/app/packages/nmc-storybook.v1/.storybook-cache,uid=1001,gid=1001 \
    pnpm build

# Export stage - minimal alpine with built static files
FROM alpine:3.19 AS export

# Security: Create non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Install minimal tools for file operations
RUN apk add --no-cache rsync ca-certificates && \
    rm -rf /var/cache/apk/*

# Copy built static files
COPY --from=build --chown=appuser:appgroup /app/packages/nmc-storybook.v1/storybook-static /storybook-static

# Switch to non-root user
USER appuser
WORKDIR /

# Default command for export
CMD ["sh"]
