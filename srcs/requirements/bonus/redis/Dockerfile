# Use the official Redis image
FROM debian:bullseye

# Copy your custom configuration file into the container
COPY redis.conf /usr/local/etc/redis/redis.conf

# Start Redis using the custom configuration
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
