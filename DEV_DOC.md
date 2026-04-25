# DEV_DOC.md

## Project Overview

This project implements a containerized web infrastructure using Docker and Docker Compose.
Each service runs in an isolated container and communicates through a dedicated bridge network.

Main services:

* NGINX (reverse proxy with HTTPS)
* WordPress (PHP-FPM application)
* MariaDB (database)
* Redis (object cache)
* FTP (file transfer)
* Adminer (database interface)

---

## Architecture

Request flow:

Browser → NGINX → WordPress → MariaDB
↘ Redis (cache)

* NGINX handles HTTPS and forwards PHP requests to WordPress via FastCGI (port 9000)
* WordPress processes application logic
* Redis is checked first for cached data
* If cache miss → WordPress queries MariaDB
* Response flows back through NGINX to the browser

---

## Docker Workflow

### Image vs Container

* Image: blueprint built from a Dockerfile (static)
* Container: running instance of an image (dynamic)

Flow:

1. Dockerfile → build image
2. Image → create container
3. Container → run service

---

## Docker Compose Role

Docker Compose is used to:

* Define multi-service architecture
* Manage networking automatically
* Attach volumes
* Start all services with one command

```bash
docker compose up --build -d
```

---

## Networking

* All containers share a bridge network (`inception`)
* Services communicate using container names:

Examples:

* `mariadb`
* `redis`
* `wordpress`

Example configuration:

```bash
DB_HOST=mariadb
```

---

## Volumes (Bind Mounts)

Persistent data is stored using bind mounts:

* `/home/salhali/data/mariadb_data` → MariaDB data
* `/home/salhali/data/wordpress_data` → WordPress files

Key behavior:

* `docker compose down` → keeps data
* `docker compose down -v` → removes volumes
* `make re` → full reset (containers, volumes, images)

Bind mounts ensure data is stored on the host and persists across container rebuilds.

---

## Service Dependency

Important distinction:

* `depends_on` → controls startup order only
* Does NOT guarantee readiness

To solve this, WordPress uses:

```bash
nc -z mariadb 3306
```

to wait until MariaDB is ready.

---

## Redis Integration

Redis is used as an object cache.

Flow:

1. WordPress receives request
2. Check Redis
3. If found → return immediately
4. If not → query MariaDB
5. Store result in Redis

Notes:

* Redis stores objects, not logs
* Runs in memory (RAM)
* Improves performance but is not required for functionality

---

## WordPress Automation (WP-CLI)

WordPress is fully automated using WP-CLI inside the container.

### Setup Flow

1. Wait for MariaDB
2. Download WordPress
3. Create `wp-config.php`
4. Install WordPress
5. Create users
6. Install Redis plugin
7. Enable Redis cache
8. Start PHP-FPM

### Example Commands

```bash
wp core download --allow-root

wp config create \
  --dbname=$DB_NAME \
  --dbuser=$DB_USER \
  --dbpass=$DB_PASS \
  --dbhost=$DB_HOST \
  --allow-root

wp core install \
  --url=$SITE_URL \
  --title=$SITE_TITLE \
  --admin_user=$ADMIN_USER \
  --admin_password=$ADMIN_PASS \
  --admin_email=$ADMIN_EMAIL \
  --allow-root

wp plugin install redis-cache --activate --allow-root
wp redis enable --allow-root
```

---

## Debugging Strategy

Common commands used:

```bash
docker ps
docker logs <container>
docker exec -it <container> bash
```

Service testing:

```bash
redis-cli
mysql -u root -p
```

This approach helps isolate infrastructure vs application issues.

---

## Common Issues (Resolved)

### Redis Connection

* Cause: using `localhost`
* Fix:

```php
define('WP_REDIS_HOST', 'redis');
```

---

### FTP Passive Mode

* Cause: ports not exposed
* Fix:

```bash
21100-21110:21100-21110
```

---

### Permissions (Bind Mounts)

* Cause: container user ≠ host user
* Fix: adjust ownership using `chown`

---

## Final Notes

* Services are isolated but interconnected
* Data persistence is handled via bind mounts
* Redis improves performance but is optional
* Configuration must be defined in Dockerfiles or scripts
* System is fully reproducible using `make re`

This architecture demonstrates container isolation, service communication, and infrastructure automation using Docker.
