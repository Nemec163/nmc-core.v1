# Simplified single-stage build for NestJS application
FROM node:20-alpine

# Security: Run as non-root user
RUN addgroup --system --gid 1001 appgroup && \
    adduser --system --uid 1001 --ingroup appgroup appuser

# Set working directory
WORKDIR /app

# Copy workspace files
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml turbo.json ./
COPY tsconfig.base.json ./

# Copy app-specific package.json
COPY apps/nmc-server.v1/package.json ./apps/nmc-server.v1/

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
    pnpm install --filter nmc-server.v1... --reporter=append-only && \
    pnpm config set strict-ssl true

# Build the application
RUN pnpm --filter nmc-server.v1 build

# Set working directory to the app
WORKDIR /app/apps/nmc-server.v1

# Network configuration
EXPOSE 3001
ENV NODE_ENV=production

# Start command
CMD ["pnpm", "start:prod"]

