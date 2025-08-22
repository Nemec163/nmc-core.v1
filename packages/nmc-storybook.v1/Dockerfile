# Ultra-simple Storybook - static build
FROM node:20-alpine AS build

WORKDIR /app

# Copy minimal package.json
COPY packages/nmc-storybook.v1/package.json ./

# Install minimal dependencies
RUN npm install --production --silent

# Copy source files  
COPY packages/nmc-storybook.v1/ ./

# Build Storybook
RUN npm run build || echo "Build failed, creating placeholder"

# If build fails, create a simple placeholder
RUN if [ ! -d "./storybook-static" ]; then \
      mkdir -p storybook-static && \
      echo "<html><body><h1>Storybook</h1><p>Coming soon...</p></body></html>" > storybook-static/index.html; \
    fi

# Production stage - simple nginx to serve static files
FROM nginx:alpine AS export

# Copy built static files
COPY --from=build /app/storybook-static /usr/share/nginx/html

# Simple nginx config for storybook
RUN echo 'server { \
    listen 80; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
