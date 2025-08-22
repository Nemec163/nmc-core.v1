# Ultra-simple Next.js build
FROM node:20-alpine AS build

WORKDIR /app

# Copy minimal package.json with core dependencies only
COPY apps/nmc-site.v1/package.json ./

# Install only production dependencies
RUN npm install --production --silent

# Copy source files
COPY apps/nmc-site.v1/src ./src
COPY apps/nmc-site.v1/public ./public
COPY apps/nmc-site.v1/next.config.ts ./
COPY apps/nmc-site.v1/tsconfig.json ./
COPY tsconfig.base.json ../

# Build the app
RUN npm run build

# Production stage
FROM node:20-alpine AS production

WORKDIR /app

# Copy only built artifacts and necessary files
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public
COPY --from=build /app/package.json ./
COPY --from=build /app/node_modules ./node_modules

EXPOSE 3000
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

CMD ["npm", "start"]
