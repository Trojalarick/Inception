# USER_DOC.md

## Project Description

This project deploys a complete WordPress infrastructure using Docker.

Available services:

* WordPress website (served via HTTPS)
* MariaDB database
* Redis cache
* Adminer (database management interface)
* FTP server (file upload)
* NGINX reverse proxy

---

## Requirements

Make sure the following are installed:

* Docker
* Docker Compose
* Make

---

## Setup

### 1. Configure environment

Edit the file:

```id="a12k9d"
srcs/.env
```

Example:

```id="b77kq1"
MYSQL_DATABASE=wordpress
MYSQL_USER=salhali
MYSQL_PASSWORD=wp_password
MYSQL_ROOT_PASSWORD=root_password
```

---

### 2. Configure domain

Add this line to `/etc/hosts`:

```id="c82md9"
127.0.0.1 yourlogin.42.fr
```

Replace `yourlogin` with your login.

---

## Usage

### Start the project

```id="d11pl0"
make
```

This will:

* Build all Docker images
* Create containers
* Start all services

---

### Stop the project

```id="e55xm2"
make down
```

---

### Remove everything (containers + volumes)

```id="f09qw3"
make clean
```

---

### Full reset (containers + volumes + images)

```id="g66rt8"
make fclean
```

---

### Rebuild from scratch

```id="h44az1"
make re
```

---

## Access Services

### WordPress

Open in browser:

```id="i93vb2"
https://yourlogin.42.fr
```

Login using credentials defined in your setup.

---

### Adminer (Database UI)

Open:

```id="j12kl4"
http://localhost:8080
```

Login with:

* System: MySQL/MariaDB
* Server: mariadb
* Username: value from `.env`
* Password: value from `.env`
* Database: wordpress

---

### FTP Server

Connect using:

```id="k88sd3"
ftp localhost
```

Login:

```id="l33xp7"
User: ftpuser
Password: ftppassword
```

Upload file example:

```id="m90zn5"
put test.txt
```

Uploaded files will appear in WordPress directory.

---

## Service Checks

### Check running containers

```id="n12cv6"
docker ps
```

---

### Check logs

```id="o77rf2"
docker logs <container_name>
```

---

### Test MariaDB

```id="p55az9"
docker exec -it mariadb mysql -u root -p
```

---

### Test Redis

```id="q21ls0"
docker exec -it redis redis-cli
KEYS *
```

---

## Expected Behavior

* WordPress loads over HTTPS
* Adminer connects to MariaDB
* Redis cache stores WordPress objects
* FTP uploads files directly into WordPress
* Data persists after container restart

---

## Notes

* If Redis is down, WordPress still works but without cache
* If MariaDB is down, WordPress will not work
* Do not modify containers manually; use Dockerfiles and scripts
* Always use `make re` after configuration changes

---
