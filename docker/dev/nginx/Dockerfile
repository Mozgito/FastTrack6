ARG NGINX_VERSION=1.21.6

FROM nginx:${NGINX_VERSION}-alpine AS app_nginx

COPY docker/dev/nginx/conf.d/default.conf /etc/nginx/conf.d

WORKDIR /app/public