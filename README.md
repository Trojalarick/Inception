# Inception

> A system administration project from **42 School** — deploying a small infrastructure using **Docker** and **Docker Compose**, with each service running in its own container.

---

## Overview

This project sets up a fully functional WordPress website served over HTTPS, using three custom Docker containers:

| Service       | Role                                      | Port  |
|---------------|-------------------------------------------|-------|
| **NGINX**     | Reverse proxy with TLS (SSL)              | 443   |
| **WordPress** | PHP-FPM application server                | 9000  |
| **MariaDB**   | Relational database backend               | 3306  |

All containers are built from **Debian Bullseye** and orchestrated via `docker-compose`.

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

- **NGINX** is the only entry point, accepting connections on port 443 (TLSv1.2/1.3).
- **WordPress** handles PHP processing via PHP-FPM and connects to MariaDB.
- **MariaDB** stores all WordPress data in a persistent Docker volume.
- All services communicate through a private Docker bridge network (`inception`).

---

## Project Structure

```
Inception/
├── Makefile
├── secrets/
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   └── tools/
        │       └── init_db.sh
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── nginx.conf
        │   └── tools/
        │       └── start.sh
        └── wordpress/
            ├── Dockerfile
            └── tools/
                └── setup.sh
```

---

## Requirements

- [Docker](https://docs.docker.com/get-docker/) (v20+)
- [Docker Compose](https://docs.docker.com/compose/) (v2+)
- GNU Make

---

## Setup

### 1. Configure environment variables

Create `srcs/.env` with the following variables:

```env
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=yourpassword
MYSQL_ROOT_PASSWORD=yourrootpassword
```

### 2. Add the domain to `/etc/hosts`

```bash
echo "127.0.0.1  salhalilogin.42.fr" | sudo tee -a /etc/hosts
```

---

## Usage

```bash
# Build and start all containers
make

# Stop all containers
make down

# Stop and remove volumes
make clean

# Full cleanup (containers, volumes, images)
make fclean

# Rebuild everything from scratch
make re
```

Once running, open your browser at:

```
https://salhalilogin.42.fr
```

> The SSL certificate is self-signed and generated at startup — your browser may show a security warning, which you can safely bypass for local development.

---

## Services

### NGINX
- Built from `debian:bullseye`
- Generates a self-signed SSL certificate on startup via `openssl`
- Supports **TLSv1.2** and **TLSv1.3** only
- Proxies PHP requests to WordPress via FastCGI

### WordPress
- Built from `debian:bullseye`
- Runs **PHP 7.4-FPM** on port 9000
- Automatically downloads and installs WordPress on first launch
- Waits for MariaDB to be ready before starting

### MariaDB
- Built from `debian:bullseye`
- Initializes the database, root password, and WordPress user on first run
- Data is persisted in a named Docker volume (`mariadb_data`)

---

## Volumes

| Volume           | Mount point           | Purpose                  |
|------------------|-----------------------|--------------------------|
| `mariadb_data`   | `/var/lib/mysql`      | Database persistence     |
| `wordpress_data` | `/var/www/html`       | WordPress files          |

---

## Network

All containers are connected to the `inception` bridge network. Only NGINX exposes a port to the host (`443`). MariaDB and WordPress are isolated from the outside.

---

## Author

**salaheddine-h** — [42 School](https://42.fr)
