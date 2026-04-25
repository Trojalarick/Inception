# DEV_DOC.md

## Project Overview

This project implements a small infrastructure using Docker and Docker Compose.
Each service runs in its own container and communicates through a private Docker network.

Main services:

* NGINX (reverse proxy with HTTPS)
* WordPress (PHP-FPM application)
* MariaDB (database)
* Redis (cache system)
* FTP (file transfer)
* Adminer (database management)

---

## Architecture

Request flow:

Browser → NGINX → WordPress → MariaDB
↘ Redis (cache)

* NGINX handles HTTPS and forwards PHP requests to WordPress via FastCGI (port 9000)
* WordPress processes logic and queries data
* Redis is checked first for cached data
* If cache miss → WordPress queries MariaDB
* Response returns back to browser through NGINX

---

## Docker Workflow

### Image vs Container

* Image: blueprint built from Dockerfile (static)
* Container: running instance of an image (dynamic)

Flow:

1. Dockerfile → build image
2. Image → create container
3. Container → run service

---

### Docker Compose Role

Docker Compose is used to:

* Define multiple services
* Manage networking automatically
* Attach volumes
* Start everything with one command

Command:

```
docker compose up --build -d
```

---

## Networking

* All containers are connected via a bridge network (`inception`)
* Services communicate using container names:

  * `mariadb`
  * `redis`
  * `wordpress`

Example:
WordPress connects to MariaDB using:

```
DB_HOST=mariadb
```

---

## Volumes (Data Persistence)

Two main volumes:

* mariadb_data → database storage
* wordpress_data → website files

Important behavior:

* `docker compose down` → keeps volumes
* `docker compose down -v` → deletes volumes
* `make re` → deletes everything (containers + volumes + images)

---

## Redis Integration

Redis is used as an object cache for WordPress.

Flow:

1. WordPress requests data
2. Check Redis
3. If found → return immediately
4. If not found → query MariaDB
5. Store result in Redis for future requests

Important:

* Redis stores objects, not logs
* Runs in RAM (in-memory)

---

## Redis Configuration Issue (Fixed)

Problem:

* WordPress could not connect to Redis
* Error: connection refused (127.0.0.1)

Cause:

* WordPress tried to connect to localhost instead of Redis container

Solution added in wp-config.php:

```
define('WP_REDIS_HOST', 'redis');
define('WP_REDIS_PORT', 6379);
```

---

## FTP Configuration Issues (Fixed)

### Problem 1: Cannot bind port 21

Error:

```
cannot expose privileged port 21
```

Cause:

* Rootless Docker cannot bind ports < 1024

Solution:

* Use port >= 1024 OR adjust system config
* Example: 2121 instead of 21

---

### Problem 2: Passive mode connection refused

Error:

```
Entering Extended Passive Mode ... connection refused
```

Cause:

* Passive ports not exposed or wrong configuration

Solution:

* Expose ports in docker-compose:

```
21100-21110:21100-21110
```

* Configure vsftpd:

```
pasv_enable=YES
pasv_min_port=21100
pasv_max_port=21110
pasv_address=127.0.0.1
```

---

### Problem 3: File upload failed (553 error)

Cause:

* Permission issue or wrong directory

Solution:

* Ensure correct ownership:

```
chown -R ftpuser:ftpuser /var/www/html
```

* Set correct root:

```
local_root=/var/www/html
```

---

### Problem 4: Config lost after rebuild

Cause:

* Manual changes inside container are not persistent

Solution:

* Move configuration into:

  * Dockerfile
  * vsftpd.conf (copied during build)
  * start.sh script

---

## Adminer Issue (Fixed)

Problem:

* "Connection refused"

Cause:

* Wrong host used

Wrong:

```
localhost
```

Correct:

```
mariadb
```

---

## Service Dependency Clarification

Important concept:

Docker `depends_on`:

* Only controls startup order
* Does NOT guarantee service readiness

Application-level dependency:

* WordPress handles failure itself

Example:

* If Redis is down:

  * WordPress still works
  * Falls back to MariaDB

---

## Useful Commands

Check containers:

```
docker ps
```

Access container:

```
docker exec -it <container> bash
```

Check logs:

```
docker logs <container>
```

Test Redis:

```
docker exec -it redis redis-cli
KEYS *
```

Test MariaDB:

```
docker exec -it mariadb mysql -u root -p
```

Test FTP:

```
ftp localhost
```

---

## Final Notes

* All services run independently but communicate through the Docker network
* Data persistence is handled via volumes
* Redis improves performance but is optional at runtime
* Configuration must always be defined in Dockerfiles or scripts, not manually inside containers
* The system is fully reproducible using `make re`

---
