# -----------------------------
# laravel 9
# 1) Frontend build (Vite)
# -----------------------------
FROM node:18-alpine AS frontend
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build


# -----------------------------
# 2) Runtime (PHP + Nginx)
# -----------------------------
FROM webdevops/php-nginx:8.1

ENV WEB_DOCUMENT_ROOT=/app/public

WORKDIR /app
COPY . .

# Assets compilados por Vite
COPY --from=frontend /app/public/build /app/public/build

# PHP deps
RUN composer install --no-dev --optimize-autoloader \
    && chown -R application:application storage bootstrap/cache

EXPOSE 80
