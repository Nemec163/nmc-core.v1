# syntax=docker/dockerfile:1.7-labs
# Multi-stage build for NestJS application with optimized caching

# Shared base image with BuildKit optimization
FROM node:20-alpine AS node-base

# Security: Run as non-root user
ARG UID=1001
ARG GID=1001
RUN addgroup --system --gid ${GID} appgroup && \
    adduser --system --uid ${UID} --ingroup appgroup appuser

# Install system dependencies and tools
RUN apk add --no-cache \
    curl \
    ca-certificates \
    tzdata \
    dumb-init && \
    # Security: Remove package cache
    rm -rf /var/cache/apk/*

# Enable and configure pnpm with caching
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable && \
    corepack prepare pnpm@latest --activate && \
    pnpm config set store-dir ~/.pnpm-store

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
COPY apps/nmc-server.v1/package.json ./apps/nmc-server.v1/

# Install dependencies with cache mount for pnpm store
RUN --mount=type=cache,target=/pnpm-cache,uid=1001,gid=1001 \
    --mount=type=cache,target=/app/node_modules/.pnpm,uid=1001,gid=1001 \
    pnpm config set node-linker hoisted && \
    pnpm install --include-workspace-root

# Build stage
FROM build-base AS build
# Copy dependencies from deps stage
COPY --from=deps --chown=appuser:appgroup /app/node_modules ./node_modules

# Copy source files for build
COPY --chown=appuser:appgroup apps/nmc-server.v1/ ./apps/nmc-server.v1/

# Switch to app user for build
USER appuser

# Build NestJS app with cache mount
RUN --mount=type=cache,target=/app/.turbo,uid=1001,gid=1001 \
    pnpm --filter nmc-server.v1 build

# Production runtime
FROM runtime-base AS runtime

# Copy package files
COPY --from=build --chown=appuser:appgroup /app/package.json ./
COPY --from=build --chown=appuser:appgroup /app/apps/nmc-server.v1/package.json ./apps/nmc-server.v1/

# Copy production dependencies only
COPY --from=deps --chown=appuser:appgroup /app/node_modules ./node_modules

# Copy built application
COPY --from=build --chown=appuser:appgroup /app/apps/nmc-server.v1/dist ./apps/nmc-server.v1/dist

# Set working directory
WORKDIR /app/apps/nmc-server.v1

# Security: Run as non-root
USER appuser

# Network configuration
EXPOSE 3001
ENV NODE_ENV=production

# Optimized health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:3001/health || exit 1

# Use tini for proper signal handling
CMD ["pnpm", "start:prod"]

