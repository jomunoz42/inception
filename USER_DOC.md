# USER_DOC

## Overview

This project provides a complete containerized web infrastructure built with Docker Compose.

The stack contains the following services:

### NGINX

* Public HTTPS entry point
* Listens on port 443
* Handles TLS encryption
* Forwards requests to WordPress

### WordPress + PHP-FPM

* Hosts the main website
* Executes PHP code
* Communicates with MariaDB
* Uses Redis cache

### MariaDB

* Stores website data
* Manages users, posts, comments, settings, and metadata

### Redis

* Provides WordPress object caching
* Reduces database queries
* Improves response times

### Adminer

* Web-based database administration tool
* Provides access to MariaDB through a browser

### FTP Server

* Provides remote access to WordPress files
* Shares the WordPress volume

### Static Portfolio Website

* Personal presentation website
* Independent from WordPress

### Status Dashboard

* Central access page for project services
* Provides links to public services

---

# Starting the Project

From the root of the repository:

```bash
make
```

This command:

* Builds Docker images
* Creates containers
* Creates volumes
* Creates the Docker network
* Starts all services

---

# Stopping the Project

Stop all services:

```bash
make down
```

Alternatively:

```bash
cd srcs
docker-compose down
```

---

# Restarting the Project

```bash
make restart
```

or

```bash
cd srcs
docker-compose restart
```

---

# Rebuilding the Infrastructure

If configuration files, secrets, or Dockerfiles are modified:

```bash
make re
```

This rebuilds all containers while preserving persistent data.

---

# Accessing Services

## Main Website

Open:

```text
https://jomunoz42.42.fr
```

The connection uses HTTPS with a self-signed certificate.

A browser warning may appear because the certificate is not signed by a public Certificate Authority.

---

## WordPress Administration Panel

Open:

```text
https://jomunoz42.42.fr/wp-admin
```

Use the administrator credentials configured during installation.

---

## Adminer

Open:

```text
http://jomunoz42.42.fr:8081
```

Use the MariaDB credentials.

Example:

```text
System: MariaDB
Server: mariadb
Username: wpuser
Password: <database password>
Database: wordpress
```

---

## Static Portfolio Website

Open:

```text
http://jomunoz42.42.fr:8080
```

---

## Status Dashboard

Open:

```text
http://jomunoz42.42.fr:8082
```

The dashboard provides links and information about the infrastructure.

---

# Credentials

Sensitive credentials are stored locally and are not tracked by Git.

Credential files:

```text
secrets/db_root_password.txt
secrets/db_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt
secrets/ftp_user.txt
secrets/ftp_password.txt
```

Configuration values are stored in:

```text
srcs/.env
```

Examples:

* Domain name
* Usernames
* Database name
* Email addresses

If credentials are modified:

```bash
make re
```

---

# FTP Usage

Connect using:

```bash
lftp -u <ftp_user>,<ftp_password> ftp://127.0.0.1
```

Useful commands:

```bash
ls
put file.txt
get file.txt
mkdir test
rm file.txt
bye
```

The FTP server shares the same volume used by WordPress.

Files uploaded through FTP become immediately available inside the WordPress filesystem.

---

# Checking Service Status

Display running containers:

```bash
docker ps
```

Expected services:

```text
nginx
wordpress
mariadb
redis
adminer
ftp
static_site
status_dashboard
```

---

# Viewing Logs

Display logs:

```bash
docker-compose -f srcs/docker-compose.yml logs
```

Follow logs:

```bash
docker-compose -f srcs/docker-compose.yml logs -f
```

---

# Service Verification

## Website

Verify HTTPS:

```bash
curl -k -I https://jomunoz42.42.fr
```

Expected:

```text
HTTP/1.1 200 OK
```

---

## Redis

Verify Redis:

```bash
docker exec -it redis redis-cli ping
```

Expected:

```text
PONG
```

---

## FTP

Verify FTP access:

```bash
lftp -u <ftp_user>,<ftp_password> ftp://127.0.0.1
```

Expected:

```text
Successful login
```

---

## Docker Network

Verify network:

```bash
docker network inspect srcs_inception
```

All services should appear in the network inspection output.

---

# Data Persistence

Project data is stored outside containers.

MariaDB data:

```text
/home/jomunoz42/data/mariadb
```

WordPress files:

```text
/home/jomunoz42/data/wordpress
```

Because data is stored in Docker volumes:

```text
Container deletion
≠
Data deletion
```

The website, database, uploads, plugins, themes, and WordPress configuration survive container recreation and system reboot.

---

# Troubleshooting

## Website Not Accessible

Check:

```bash
docker ps
```

Verify that all required containers are running.

---

## Container Logs

Inspect individual logs:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
docker logs redis
docker logs ftp
```

---

## Rebuild Everything

To completely rebuild the infrastructure:

```bash
make re
```

---

# Administrator Checklist

After deployment verify:

* HTTPS website accessible
* WordPress login functional
* Adminer accessible
* Redis responding
* FTP login functional
* Static website accessible
* Dashboard accessible
* Persistent volumes populated
* Docker network operational

If all checks pass, the infrastructure is functioning correctly.

