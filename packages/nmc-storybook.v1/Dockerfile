# Simplified single-stage build for Storybook
FROM node:20-alpine

# Security: Run as non-root user
RUN addgroup --system --gid 1001 appgroup && \
    adduser --system --uid 1001 --ingroup appgroup appuser

# Set working directory
WORKDIR /app

# Set memory limit for large builds
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Copy workspace files
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml turbo.json ./
COPY tsconfig.base.json ./

# Copy package manifests
COPY packages/nmc-storybook.v1/package.json ./packages/nmc-storybook.v1/
COPY packages/nmc-ui.v1/package.json ./packages/nmc-ui.v1/

# Copy all source files and set ownership
COPY . .
RUN chown -R appuser:appgroup /app

# Install pnpm globally as root (with SSL workaround for build environment)
RUN npm config set strict-ssl false && \
    npm install -g pnpm@latest && \
    npm config set strict-ssl true

# Switch to app user
USER appuser

# Install project dependencies
RUN pnpm config set strict-ssl false && \
    pnpm install --filter nmc-storybook.v1... --reporter=append-only && \
    pnpm config set strict-ssl true

# Build UI package first
RUN pnpm --filter nmc-ui.v1 build

# Set working directory to storybook package
WORKDIR /app/packages/nmc-storybook.v1

# Build Storybook
RUN NODE_OPTIONS="--max-old-space-size=4096" pnpm build

# Export stage - minimal alpine with built static files
FROM alpine:3.19 AS export

# Security: Create non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Copy built static files
COPY --from=0 --chown=appuser:appgroup /app/packages/nmc-storybook.v1/storybook-static /storybook-static

# Switch to non-root user
USER appuser
WORKDIR /

# Default command for export
CMD ["sh"]
