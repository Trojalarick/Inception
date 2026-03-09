# Inception

> A system administration project from **42 School** -- deploying a small infrastructure using **Docker** and **Docker Compose**, with each service running in its own dedicated container.

---

## Overview

This project sets up a fully functional WordPress website served over HTTPS, using three custom-built Docker containers:

| Service       | Role                              | Exposed port    |
|---------------|-----------------------------------|-----------------|
| **NGINX**     | Reverse proxy with TLS (SSL)      | 443 (host)      |
| **WordPress** | PHP-FPM application server        | 9000 (internal) |
| **MariaDB**   | Relational database backend       | 3306 (internal) |

All images are built from **Debian Bullseye** and orchestrated via `docker compose`.

---

## Architecture

```
                    HTTPS (port 443)
User ──────────────────► NGINX
                            │
                    FastCGI (port 9000)
                            ▼
                       WordPress (PHP-FPM)
                            │
                      MySQL (port 3306)
                            ▼
                         MariaDB
```

- **NGINX** is the only external entry point, listening on port 443 (TLSv1.2 / TLSv1.3).
- **WordPress** handles PHP processing via PHP-FPM and connects to MariaDB.
- **MariaDB** stores all WordPress data in a persistent Docker volume.
- All three services communicate over a private Docker bridge network (`inception`).

---

## Project Structure

```
Inception/
├── Makefile
├── secrets/
│   ├── credentials.tx          # WordPress admin credentials
│   ├── db_password.txt         # MariaDB user password
│   └── db_root_password.txt    # MariaDB root password
└── srcs/
    ├── .env                    # Environment variables for docker compose
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   └── tools/
        │       └── init_db.sh      # DB init + user setup script
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── nginx.conf      # NGINX + TLS configuration
        │   └── tools/
        │       └── start.sh        # SSL cert generation + nginx start
        └── wordpress/
            ├── Dockerfile
            └── tools/
                └── setup.sh        # WordPress download + PHP-FPM start
```

---

## Requirements

- [Docker](https://docs.docker.com/get-docker/) (v20+)
- [Docker Compose](https://docs.docker.com/compose/) (v2+)
- GNU Make

---

## Setup

### 1. Configure environment variables

Create `srcs/.env` with the following:

```env
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=<your_db_password>
MYSQL_ROOT_PASSWORD=<your_db_root_password>
```

> These values should match the passwords stored in the `secrets/` files.

### 2. Add the domain to `/etc/hosts`

```bash
echo "127.0.0.1  salhalilogin.42.fr" | sudo tee -a /etc/hosts
```

> To use a different 42 login, also update `server_name` in `srcs/requirements/nginx/conf/nginx.conf` and the `-subj` flag in `srcs/requirements/nginx/tools/start.sh`.

---

## Usage

```bash
# Build images and start all containers (detached)
make

# Stop all running containers
make down

# Stop containers and remove volumes
make clean

# Full cleanup: containers, volumes, and all built images
make fclean

# Rebuild everything from scratch
make re
```

Once running, visit:

```
https://salhalilogin.42.fr
```

> A self-signed SSL certificate is generated automatically at container startup. Your browser will show a security warning -- this is expected for local development and can be safely bypassed.

---

## Services

### NGINX
- Built from `debian:bullseye`
- On startup, generates a self-signed RSA-2048 certificate valid for 365 days via `openssl`
- Only accepts **TLSv1.2** and **TLSv1.3** -- older protocols are disabled
- Routes all `.php` requests to WordPress over FastCGI on port 9000
- Serves static files directly from the shared `wordpress_data` volume

### WordPress
- Built from `debian:bullseye`
- Runs **PHP 7.4-FPM** listening on TCP port 9000 (not a Unix socket)
- On first start: downloads the latest WordPress tarball, extracts it, and writes `wp-config.php` from environment variables
- Uses `netcat` to poll MariaDB on port 3306 and waits for it to be ready before starting PHP-FPM

### MariaDB
- Built from `debian:bullseye`
- On first start: initialises the data directory with `mysql_install_db`, spins up a temporary instance to create the database, WordPress user, and root password, then restarts normally
- Binds to `0.0.0.0` so WordPress can reach it over the Docker network
- Data is persisted in a named Docker volume (`mariadb_data`)

---

## Volumes

| Volume           | Container mount point | Purpose                             |
|------------------|-----------------------|-------------------------------------|
| `mariadb_data`   | `/var/lib/mysql`      | MariaDB database persistence        |
| `wordpress_data` | `/var/www/html`       | WordPress files (shared with NGINX) |

---

## Network

All containers are attached to the `inception` bridge network. Only NGINX publishes a port to the host (`443:443`). WordPress and MariaDB are not directly reachable from outside the Docker network.

---

## Author

**alarick** -- [42 School](https://42.fr)