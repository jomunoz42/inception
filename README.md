*This project has been created as part of the 42 curriculum by jomunoz.*

# Inception

## Description

Inception is a System Administration project from the 42 curriculum focused on containerization using Docker and Docker Compose.

The objective of the project is to build a small infrastructure composed of multiple isolated services running in dedicated Docker containers. Each service has a single responsibility and communicates with the others through a dedicated Docker network.

The infrastructure contains:

* NGINX configured with TLSv1.2/TLSv1.3
* WordPress with php-fpm
* MariaDB
* Redis cache
* Adminer
* FTP server
* Static portfolio website
* Infrastructure status dashboard
* Persistent Docker volumes
* Dedicated Docker network

---

## Architecture

```text
                               WWW
                                |
      ---------------------------------------------------
      |                 |                |             |
     443              8080             8081          8082
      |                 |                |             |
   NGINX          Static Site         Adminer      Dashboard
      |
    9000
      |
 WordPress + php-fpm
      |
    3306
      |
   MariaDB

WordPress <------> Redis (6379)

FTP (21)
   |
   v
WordPress Volume
```

Data persistence is ensured through Docker volumes stored on the host machine under:

```text
/home/jomunoz42/data
```

---

# Docker Overview

Docker allows applications and their dependencies to be packaged into isolated environments called containers.

In this project:

* Each service runs inside its own container.
* Containers communicate through a dedicated Docker network.
* Docker volumes provide persistent storage.
* Docker Compose orchestrates the complete infrastructure.

---

# Services

## NGINX

* Public entry point of the mandatory infrastructure
* Exposes HTTPS on port 443
* Handles TLS encryption
* Forwards PHP requests to php-fpm

## WordPress + php-fpm

* Hosts the WordPress application
* Executes PHP code through php-fpm
* Communicates with MariaDB
* Uses Redis object caching

## MariaDB

* Stores WordPress data
* Manages users, posts, comments, settings, and metadata

## Redis

* Object cache for WordPress
* Stores frequently requested data in memory
* Reduces database queries
* Improves response times

## Adminer

* Web-based database administration interface
* Connects directly to MariaDB
* Allows inspection and management of database contents

## FTP Server

* Provides remote access to WordPress files
* Shares the same WordPress volume used by WordPress
* Allows uploading and downloading website files

## Static Portfolio Website

* Personal presentation website
* Built using HTML, CSS and JavaScript
* Completely independent from WordPress

## Status Dashboard

* Central access page for project services
* Provides quick links to public services
* Simplifies infrastructure administration

---

# Design Choices

## Virtual Machines vs Docker

### Virtual Machines

* Virtualize an entire operating system
* Include their own kernel
* Consume more RAM and disk space
* Slower startup times

### Docker

* Virtualizes applications
* Shares the host kernel
* Lightweight and efficient
* Fast startup times

Docker is particularly suited for infrastructures composed of multiple isolated services.

---

## Secrets vs Environment Variables

### Environment Variables

Used for non-sensitive configuration values:

* Domain names
* Usernames
* Database names
* Ports

### Docker Secrets

Used for sensitive information:

* Database passwords
* FTP credentials
* WordPress administrator password
* WordPress user password

Secrets are mounted as files inside containers and avoid exposing credentials directly inside configuration files.

---

## Docker Network vs Host Network

### Host Network

Containers share the host networking stack.

Advantages:

* Simpler networking

Disadvantages:

* Reduced isolation
* Port conflicts
* Lower security

### Docker Network

Containers communicate through an isolated virtual network.

Advantages:

* Better isolation
* Automatic service discovery
* Easier management
* Increased security

This project uses a dedicated Docker bridge network.

---

## Docker Volumes vs Bind Mounts

### Bind Mounts

Direct mapping between a host directory and a container directory.

Advantages:

* Easy host-side access

Disadvantages:

* Tight coupling with host filesystem

### Docker Volumes

Docker-managed persistent storage.

Advantages:

* Better portability
* Easier management
* Recommended for application data

This project uses persistent Docker volumes whose data is stored under:

```text
/home/jomunoz42/data
```

---

# Bonus Features

This implementation includes all bonus services:

* Redis object cache
* Adminer database administration interface
* FTP server sharing the WordPress volume
* Personal static portfolio website
* Infrastructure status dashboard

---

# Instructions

## Clone Repository

```bash
git clone <repository_url>
cd inception
```

## Configure Environment

Create:

```text
srcs/.env
```

and:

```text
secrets/
```

with the required credentials.

---

## Build and Start

```bash
make
```

or

```bash
cd srcs
docker-compose up --build -d
```

---

## Stop Infrastructure

```bash
make down
```

---

## Rebuild Infrastructure

```bash
make re
```

---

# Project Structure

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

# Resources

## Official Documentation

* Docker Documentation
* Docker Compose Documentation
* NGINX Documentation
* MariaDB Documentation
* WordPress Documentation
* PHP-FPM Documentation
* Redis Documentation
* Adminer Documentation
* VSFTPD Documentation

---

## Learning Resources

* Docker Deep Dive — Nigel Poulton
* Docker Networking Documentation
* Docker Volumes Documentation
* Redis Official Documentation
* WordPress Developer Documentation

---

## AI Usage

AI tools were used as learning assistants during development.

They were primarily used to:

* Clarify Docker concepts
* Understand Docker networking and Docker volumes
* Understand container orchestration with Docker Compose
* Review architecture decisions
* Debug configuration issues
* Improve project documentation
* Reinforce system administration concepts

All configurations, scripts, Dockerfiles, architecture decisions, and deployments were manually reviewed, tested, adapted, and validated before inclusion in the final project.

---

## Conclusion

This project demonstrates the deployment of a complete containerized infrastructure using Docker Compose, emphasizing service isolation, networking, persistence, security, automation, and maintainability.

The final infrastructure includes both the mandatory architecture and a complete set of bonus services, each running in its own dedicated container and integrated through a shared Docker ecosystem.

