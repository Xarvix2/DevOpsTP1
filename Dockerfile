FROM nginx:1.29.5-alpine

LABEL maintainer="TP DevOps"
LABEL description="Application DevOps sécurisée"
LABEL org.opencontainers.image.source="https://github.com/Xarvix2/DevOpsTP1"

RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

RUN apk add --no-cache ca-certificates && \
    rm -rf /var/cache/apk/*

COPY --chown=appuser:appgroup nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --chown=appuser:appgroup src/ /usr/share/nginx/html/

RUN chown -R appuser:appgroup /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

RUN touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/cache/nginx

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
 CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
