# USER_DOC.md

## Project Description

This project deploys a complete WordPress infrastructure using Docker.

Available services:

* WordPress (HTTPS website)
* MariaDB (database)
* Redis (cache)
* Adminer (database interface)
* FTP server (file upload)
* NGINX (reverse proxy)

---

## Requirements

Install:

* Docker
* Docker Compose
* Make

---

## Setup

### 1. Configure Environment

Edit:

```bash
srcs/.env
```

Example:

```env
DB_NAME=wordpress
DB_USER=salhali
DB_PASS=wp_password
DB_HOST=mariadb

ADMIN_USER=admin
ADMIN_PASS=admin_password
ADMIN_EMAIL=admin@example.com
```

---

### 2. Configure Domain

Add to `/etc/hosts`:

```bash
127.0.0.1 yourlogin.42.fr
```

---

## Usage

### Start

```bash
make
```

---

### Stop

```bash
make down
```

---

### Remove Containers + Volumes

```bash
make clean
```

---

### Full Reset

```bash
make fclean
```

---

### Rebuild

```bash
make re
```

---

## Access Services

### WordPress

```text
https://yourlogin.42.fr
```

---

### Adminer

```text
http://localhost:8080
```

Login:

* System: MySQL/MariaDB
* Server: mariadb
* Username: from `.env`
* Password: from `.env`
* Database: wordpress

---

### FTP

Connect:

```bash
ftp localhost
```

Login:

```text
User: ftpuser
Password: ftppassword
```

Upload file:

```bash
put test.txt
```

Files will appear in WordPress directory.

---

## Service Checks

### Containers

```bash
docker ps
```

---

### Logs

```bash
docker logs <container>
```

---

### MariaDB

```bash
docker exec -it mariadb mysql -u root -p
```

---

### Redis

```bash
docker exec -it redis redis-cli
KEYS *
```

---

## Expected Behavior

* WordPress loads via HTTPS
* Adminer connects to MariaDB
* Redis caches WordPress data
* FTP uploads files to WordPress
* Data persists after restart

---

## Notes

* If Redis is down → WordPress still works (no cache)
* If MariaDB is down → WordPress will not work
* Do not modify containers manually
* Use Dockerfiles and scripts for changes
* Use `make re` after major configuration updates
