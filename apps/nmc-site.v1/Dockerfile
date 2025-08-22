# Simplified single-stage build for Next.js application
FROM node:20-alpine

# Security: Run as non-root user
RUN addgroup --system --gid 1001 appgroup && \
    adduser --system --uid 1001 --ingroup appgroup appuser

# Set working directory
WORKDIR /app

# Copy workspace files
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml turbo.json ./
COPY tsconfig.base.json ./

# Copy package manifests
COPY apps/nmc-site.v1/package.json ./apps/nmc-site.v1/
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
    pnpm install --reporter=append-only && \
    pnpm config set strict-ssl true

# Build dependencies first (UI package)
RUN pnpm --filter nmc-ui.v1 build

# Build Next.js app
RUN pnpm --filter nmc-site.v1 build

# Set working directory to the app
WORKDIR /app/apps/nmc-site.v1

# Network configuration
EXPOSE 3000
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Start command
CMD ["pnpm", "start"]
