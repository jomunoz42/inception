# USER_DOC

## Overview

This project provides a small web infrastructure built with Docker Compose.

The stack contains the following services:

### NGINX

* HTTPS entry point of the infrastructure
* Listens on port 443
* Handles TLS encryption
* Forwards requests to WordPress

### WordPress + PHP-FPM

* Hosts the website
* Executes PHP code
* Communicates with MariaDB

### MariaDB

* Stores website data
* Manages users, posts, comments, settings, and metadata

---

## Starting the Project

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

## Stopping the Project

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

## Restarting the Project

```bash
make restart
```

or

```bash
cd srcs
docker-compose restart
```

---

## Accessing the Website

Open a web browser and navigate to:

```text
https://jomunoz42.42.fr
```

The connection uses HTTPS with a self-signed certificate.

Depending on the browser, a security warning may appear because the certificate is not signed by a public Certificate Authority.

---

## Accessing the WordPress Administration Panel

Open:

```text
https://jomunoz42.42.fr/wp-admin
```

Use the administrator credentials configured during installation.

---

## Credential Management

Credentials are stored locally and are not tracked by Git.

Sensitive credentials are stored in:

```text
secrets/
```

Examples:

```text
secrets/db_password.txt
secrets/db_root_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt
```

Configuration values are stored in:

```text
srcs/.env
```

Examples:

* Domain name
* Usernames
* Database name

If credentials are modified, rebuild the infrastructure:

```bash
make re
```

---

## Checking Service Status

Display running containers:

```bash
docker ps
```

Expected services:

```text
nginx
wordpress
mariadb
```

---

## Viewing Logs

Display logs for all services:

```bash
docker-compose -f srcs/docker-compose.yml logs
```

Follow logs in real time:

```bash
docker-compose -f srcs/docker-compose.yml logs -f
```

---

## Verifying Website Availability

Check that the website responds correctly:

```bash
curl -k -I https://jomunoz42.42.fr
```

Expected result:

```text
HTTP/1.1 200 OK
```

---

## Data Persistence

Project data is stored outside containers.

MariaDB data:

```text
/home/jomunoz42/data/mariadb
```

WordPress files:

```text
/home/jomunoz42/data/wordpress
```

Because the data is stored in Docker volumes, it survives container deletion and recreation.

---

## Troubleshooting

### Website Not Accessible

Check:

```bash
docker ps
```

Verify that:

```text
nginx
wordpress
mariadb
```

are running.

---

### Container Logs

Inspect logs:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

---

### Rebuild Everything

To completely rebuild the infrastructure:

```bash
make re
```

