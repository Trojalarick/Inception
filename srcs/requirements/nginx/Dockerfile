FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Copy custom configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Copy startup script
COPY tools/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Expose port 443 for HTTPS
EXPOSE 443

# Start NGINX using startup script
CMD ["/usr/local/bin/start.sh"]

