# DEV_DOC

## Purpose

This document explains how to set up, build, run, debug, and maintain the Inception infrastructure.

It is intended for developers who need to understand the architecture, deployment process, and maintenance procedures of the project.

---

# Prerequisites

The project was developed and tested on:

* Debian 12 (Bookworm)
* Docker
* Docker Compose

Required packages:

```bash
sudo apt update
sudo apt install docker.io docker-compose git
```

Verify installation:

```bash
docker --version
docker-compose --version
```

---

# Repository Structure

```text
inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── mariadb/
        ├── nginx/
        ├── wordpress/
        └── bonus/
            ├── redis/
            ├── adminer/
            ├── ftp/
            ├── static_site/
            └── status_dashboard/
```

---

# Initial Setup

## Persistent Data Directories

Create the host directories required by the project:

```bash
mkdir -p /home/jomunoz42/data/mariadb
mkdir -p /home/jomunoz42/data/wordpress
```

These directories store persistent data outside containers.

---

## Environment Variables

Configure:

```text
srcs/.env
```

Example:

```env
DOMAIN_NAME=jomunoz42.42.fr

MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser

WP_ADMIN_USER=superuser
WP_ADMIN_EMAIL=admin@test.com

WP_USER=user42
WP_USER_EMAIL=user42@test.com
```

Only non-sensitive values should be stored here.

---

## Secrets

Create:

```text
secrets/
```

Example:

```bash
echo "root_password" > secrets/db_root_password.txt
echo "database_password" > secrets/db_password.txt
echo "admin_password" > secrets/wp_admin_password.txt
echo "user_password" > secrets/wp_user_password.txt

echo "ftpuser" > secrets/ftp_user.txt
echo "ftppass" > secrets/ftp_password.txt
```

Secrets are mounted inside containers and are ignored by Git.

---

# Building and Launching

## Using Makefile

Build and start:

```bash
make
```

Stop containers:

```bash
make down
```

Restart infrastructure:

```bash
make restart
```

Rebuild everything:

```bash
make re
```

Remove containers:

```bash
make clean
```

Full cleanup:

```bash
make fclean
```

---

## Using Docker Compose

Move to:

```bash
cd srcs
```

Build:

```bash
docker-compose build
```

Launch:

```bash
docker-compose up -d
```

Stop:

```bash
docker-compose down
```

Rebuild:

```bash
docker-compose up --build -d
```

---

# Service Overview

## NGINX

Responsibilities:

* HTTPS entry point
* TLS certificate management
* Reverse proxy
* FastCGI forwarding

Port:

```text
443
```

---

## WordPress + PHP-FPM

Responsibilities:

* Execute PHP code
* Serve WordPress application
* Communicate with MariaDB
* Use Redis cache

Internal port:

```text
9000
```

---

## MariaDB

Responsibilities:

* Store website data
* Manage users
* Persist posts, comments, settings and metadata

Internal port:

```text
3306
```

---

## Redis

Responsibilities:

* Object caching
* Reduce database queries
* Improve WordPress performance

Internal port:

```text
6379
```

---

## Adminer

Responsibilities:

* Database administration
* MariaDB inspection
* Query execution

Public port:

```text
8081
```

---

## FTP

Responsibilities:

* Remote file transfer
* Shared access to WordPress files
* Upload and download website content

Public port:

```text
21
```

Passive ports:

```text
21100-21110
```

---

## Static Portfolio Website

Responsibilities:

* Personal presentation page
* Demonstration of static web hosting

Public port:

```text
8080
```

---

## Status Dashboard

Responsibilities:

* Centralized access page
* Navigation hub for project services

Public port:

```text
8082
```

---

# Docker Network

All containers are attached to the dedicated Docker bridge network:

```text
inception
```

Communication examples:

```text
nginx
  |
  v
wordpress:9000

wordpress
  |
  v
mariadb:3306

wordpress
  |
  v
redis:6379

adminer
  |
  v
mariadb:3306
```

Docker service names act as DNS names inside the network.

---

# Volumes

## MariaDB Volume

Host path:

```text
/home/jomunoz42/data/mariadb
```

Stores:

* databases
* tables
* users
* metadata

---

## WordPress Volume

Host path:

```text
/home/jomunoz42/data/wordpress
```

Stores:

* WordPress installation
* themes
* plugins
* uploads
* configuration files

Shared by:

```text
WordPress
FTP
```

---

# Data Persistence

Because the infrastructure uses persistent volumes:

```text
Container deletion
≠
Data deletion
```

Containers may be rebuilt without losing:

* website content
* database content
* WordPress configuration
* uploaded files

---

# Managing Containers

List running containers:

```bash
docker ps
```

List all containers:

```bash
docker ps -a
```

Open a shell:

```bash
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash
docker exec -it redis bash
docker exec -it ftp bash
```

---

# Logs

View logs:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
docker logs redis
docker logs ftp
```

Follow all logs:

```bash
docker-compose logs -f
```

---

# Useful Debugging Commands

Verify website:

```bash
curl -k -I https://jomunoz42.42.fr
```

Expected:

```text
HTTP/1.1 200 OK
```

---

Verify Redis:

```bash
docker exec -it redis redis-cli ping
```

Expected:

```text
PONG
```

---

Verify FTP:

```bash
lftp -u ftpuser,ftppass ftp://127.0.0.1
```

---

Verify Adminer:

Open:

```text
http://jomunoz42.42.fr:8081
```

---

Verify Docker network:

```bash
docker network inspect srcs_inception
```

---

Verify persistence:

```bash
ls -la /home/jomunoz42/data/mariadb
ls -la /home/jomunoz42/data/wordpress
```

---

# Verification Checklist

After deployment:

* NGINX reachable through HTTPS
* WordPress accessible
* MariaDB initialized
* Redis connected
* Adminer accessible
* FTP login functional
* Static website accessible
* Dashboard accessible
* Persistent volumes populated
* Docker network operational

If all checks pass, the infrastructure is correctly deployed.

