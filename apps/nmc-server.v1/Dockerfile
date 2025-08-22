# Ultra-simple NestJS build
FROM node:20-alpine AS build

WORKDIR /app

# Copy minimal package.json with core dependencies only
COPY apps/nmc-server.v1/package.json ./

# Install only core dependencies (reduced set)
RUN npm install --production --silent

# Copy source files
COPY apps/nmc-server.v1/src ./src
COPY apps/nmc-server.v1/tsconfig.json ./
COPY apps/nmc-server.v1/tsconfig.build.json ./
COPY tsconfig.base.json ../

# Build the app
RUN npm run build

# Production stage
FROM node:20-alpine AS production

WORKDIR /app

# Copy only built artifacts and necessary files
COPY --from=build /app/dist ./dist
COPY --from=build /app/package.json ./
COPY --from=build /app/node_modules ./node_modules

EXPOSE 3001
ENV NODE_ENV=production

CMD ["npm", "run", "start:prod"]

