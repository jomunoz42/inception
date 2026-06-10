# DEV_DOC

## Purpose

This document explains how to set up, build, run, and maintain the Inception infrastructure from scratch.

It is intended for developers who need to understand the project's architecture and development workflow.

---

# Prerequisites

The project was developed on:

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
        │   ├── Dockerfile
        │   └── tools/
        ├── wordpress/
        │   ├── Dockerfile
        │   └── tools/
        └── nginx/
            ├── Dockerfile
            └── conf/
```

---

# Initial Setup

## Create Required Directories

Persistent data is stored on the host machine:

```bash
mkdir -p /home/jomunoz42/data/mariadb
mkdir -p /home/jomunoz42/data/wordpress
```

---

## Configure Environment Variables

Edit:

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

---

## Configure Docker Secrets

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
```

Docker mounts these files inside containers through Docker secrets.

---

# Building and Launching

## Using Makefile

Build and start:

```bash
make
```

Stop:

```bash
make down
```

Restart:

```bash
make restart
```

Rebuild everything:

```bash
make re
```

Clean containers:

```bash
make clean
```

Full cleanup:

```bash
make fclean
```

---

## Using Docker Compose Directly

Move to:

```bash
cd srcs
```

Build:

```bash
docker-compose build
```

Start:

```bash
docker-compose up -d
```

Stop:

```bash
docker-compose down
```

Rebuild:

```bash
docker-compose up --build
```

---

# Service Overview

## NGINX

Responsibilities:

* HTTPS endpoint
* TLS handling
* Reverse proxy
* FastCGI forwarding to PHP-FPM

Exposed port:

```text
443
```

---

## WordPress + PHP-FPM

Responsibilities:

* Execute PHP code
* Host WordPress application
* Communicate with MariaDB

Internal port:

```text
9000
```

---

## MariaDB

Responsibilities:

* Store website data
* Manage users and permissions
* Persist WordPress content

Internal port:

```text
3306
```

---

# Docker Network

All services are connected through:

```text
inception
```

Docker network.

Communication example:

```text
NGINX
  |
  v
wordpress:9000
  |
  v
mariadb:3306
```

Service names act as DNS names inside the network.

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

Open a shell inside a container:

```bash
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash
```

View logs:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

Follow logs:

```bash
docker-compose logs -f
```

---

# Managing Volumes

List volumes:

```bash
docker volume ls
```

Inspect volume:

```bash
docker volume inspect mariadb_data
docker volume inspect wordpress_data
```

Remove volumes:

```bash
docker-compose down -v
```

---

# Data Persistence

The infrastructure uses Docker named volumes.

MariaDB data:

```text
/home/jomunoz42/data/mariadb
```

Contains:

* databases
* tables
* users
* metadata

---

WordPress data:

```text
/home/jomunoz42/data/wordpress
```

Contains:

* WordPress files
* themes
* plugins
* uploads
* configuration files

---

Because the data is stored outside containers:

```text
Container deletion
≠
Data deletion
```

Containers can be rebuilt while preserving application data.

---

# Verification Commands

Verify containers:

```bash
docker ps
```

Verify website:

```bash
curl -k -I https://jomunoz42.42.fr
```

Expected:

```text
HTTP/1.1 200 OK
```

Verify Docker network:

```bash
docker network inspect srcs_inception
```

Verify persistence directories:

```bash
ls -la /home/jomunoz42/data/mariadb
ls -la /home/jomunoz42/data/wordpress
```
 
