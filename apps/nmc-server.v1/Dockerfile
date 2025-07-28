# syntax=docker/dockerfile:1.7-labs  
# Multi-stage build for NestJS application with optimized caching

# Import shared base
FROM ../../docker/Dockerfile.base AS base

# Dependencies stage with cache mount
FROM deps-base AS deps
# Copy package manifests for optimal layer caching
COPY apps/nmc-server.v1/package.json ./apps/nmc-server.v1/

# Install dependencies with cache mount for pnpm store
RUN --mount=type=cache,target=/pnpm-cache,uid=1001,gid=1001 \
    --mount=type=cache,target=/app/node_modules/.pnpm,uid=1001,gid=1001 \
    pnpm install --frozen-lockfile --filter nmc-server.v1

# Build stage
FROM build-base AS build
# Copy dependencies from deps stage
COPY --from=deps --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --from=deps --chown=appuser:appgroup /app/apps/nmc-server.v1/node_modules ./apps/nmc-server.v1/node_modules

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
