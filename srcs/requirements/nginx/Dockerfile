FROM debian:bullseye


RUN apt-get update && apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=MA/ST=Morocco/L=benguerir/O=42/OU=1337/CN=salhali.42.fr"

# Copy custom configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Copy startup script
COPY tools/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Expose port 443 for HTTPS
EXPOSE 443

# Start NGINX using startup script
CMD ["/usr/local/bin/start.sh"]

