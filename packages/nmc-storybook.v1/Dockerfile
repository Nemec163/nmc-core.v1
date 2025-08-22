# syntax=docker/dockerfile:1.7-labs
# Multi-stage build for Storybook with optimized caching

# Shared base image with BuildKit optimization
FROM node:20-alpine AS node-base

# Security: Run as non-root user
ARG UID=1001
ARG GID=1001
RUN addgroup --system --gid ${GID} appgroup && \
    adduser --system --uid ${UID} --ingroup appgroup appuser

# Install system dependencies and tools
# RUN apk add --no-cache curl && \
#     # Security: Remove package cache
#     rm -rf /var/cache/apk/*

# Enable and configure pnpm with caching
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
# Set pnpm configuration for better stability
ENV PNPM_TIMEOUT=300000
ENV CI=true
ENV NODE_OPTIONS="--max-old-space-size=4096"
RUN corepack enable

# Set working directory
WORKDIR /app

# Cache mount for pnpm store
ENV PNPM_CACHE_FOLDER=/pnpm-cache

# Dependencies stage with optimized caching
FROM node-base AS deps-base
# Copy workspace files for dependency resolution
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml turbo.json ./
COPY tsconfig.base.json ./

# Create cache directories
RUN mkdir -p /pnpm-cache && chown -R appuser:appgroup /pnpm-cache /app

# Build stage base
FROM node-base AS build-base
# Copy all source files (will be filtered by specific builds)
COPY --chown=appuser:appgroup . .
RUN chown -R appuser:appgroup /app

# Production runtime base
FROM node-base AS runtime-base

# Dependencies stage with cache mount
FROM deps-base AS deps
# Copy package manifests for optimal layer caching
COPY packages/nmc-storybook.v1/package.json ./packages/nmc-storybook.v1/
COPY packages/nmc-ui.v1/package.json ./packages/nmc-ui.v1/

# Install dependencies with cache mount for pnpm store
RUN --mount=type=cache,target=/pnpm-cache,uid=1001,gid=1001 \
    --mount=type=cache,target=/app/node_modules/.pnpm,uid=1001,gid=1001 \
    pnpm config set node-linker hoisted && \
    pnpm install \
        --filter nmc-storybook.v1... \
        --reporter=append-only \
        --fetch-timeout=300000

# Build stage
FROM build-base AS build
# Copy dependencies from deps stage
COPY --from=deps --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --from=deps --chown=appuser:appgroup /app/packages/ ./packages/

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
    NODE_OPTIONS="--max-old-space-size=4096" pnpm build

# Export stage - minimal alpine with built static files
FROM alpine:3.19 AS export

# Security: Create non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Install minimal tools for file operations
# RUN apk add --no-cache rsync && \
#     rm -rf /var/cache/apk/*

# Copy built static files
COPY --from=build --chown=appuser:appgroup /app/packages/nmc-storybook.v1/storybook-static /storybook-static

# Switch to non-root user
USER appuser
WORKDIR /

# Default command for export
CMD ["sh"]
