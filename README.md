*This project has been created as part of the 42 curriculum by jomunoz.*

# Inception

## Description

Inception is a System Administration project from the 42 curriculum focused on containerization using Docker and Docker Compose.

The goal of the project is to build a small infrastructure composed of multiple isolated services running in dedicated Docker containers. Each service is responsible for a specific task and communicates with the others through a Docker network.

The mandatory infrastructure contains:

* NGINX configured with TLSv1.2/TLSv1.3
* WordPress with php-fpm
* MariaDB
* Persistent Docker volumes for database and website data
* A dedicated Docker network connecting all services

### Architecture

```text
Browser
    |
 HTTPS (443)
    |
    v
NGINX
    |
 FastCGI
    |
    v
WordPress + php-fpm
    |
 SQL
    |
    v
MariaDB
```

Data persistence is ensured through Docker volumes stored on the host machine.

---

## Docker Overview

Docker allows applications and their dependencies to be packaged into isolated environments called containers.

In this project:

* Each service runs in its own container.
* Containers communicate through a Docker network.
* Docker volumes provide persistent storage.
* Docker Compose orchestrates the entire infrastructure.

### Services

#### NGINX

* Only public entry point of the infrastructure
* Exposes HTTPS on port 443
* Handles TLS encryption
* Forwards PHP requests to php-fpm

#### WordPress + php-fpm

* Hosts the WordPress application
* Executes PHP code through php-fpm
* Communicates with MariaDB

#### MariaDB

* Stores WordPress data
* Manages users, posts, comments, settings, and metadata

---

## Design Choices

### Virtual Machines vs Docker

#### Virtual Machines

* Virtualize an entire operating system
* Include a dedicated kernel
* Consume more RAM and disk space
* Slower startup times

#### Docker

* Virtualizes applications
* Shares the host kernel
* Lightweight and efficient
* Fast startup times

Docker is better suited for deploying multiple isolated services.

---

### Secrets vs Environment Variables

#### Environment Variables

Used for non-sensitive configuration values such as:

* Domain names
* Usernames
* Database names

#### Docker Secrets

Used for sensitive information such as:

* Database passwords
* Administrator passwords

Secrets are mounted as files inside containers and avoid exposing credentials directly in configuration files.

---

### Docker Network vs Host Network

#### Host Network

Containers share the host's network stack directly.

Advantages:

* Simpler networking

Disadvantages:

* Reduced isolation
* Port conflicts
* Less secure

#### Docker Network

Containers communicate through an isolated virtual network.

Advantages:

* Better isolation
* Automatic service discovery
* Easier management

This project uses a dedicated Docker bridge network.

---

### Docker Volumes vs Bind Mounts

#### Bind Mounts

Direct mapping between a host directory and a container directory.

Advantages:

* Easy access to files from the host

Disadvantages:

* Tight coupling with host filesystem

#### Docker Volumes

Docker-managed persistent storage.

Advantages:

* Better portability
* Easier management
* Recommended for persistent application data

This project uses Docker named volumes whose data is stored under:

```text
/home/jomunoz42/data
```

---

## Instructions

### Clone the Repository

```bash
git clone <repository_url>
cd inception
```

### Configure Environment

Create the required secrets and environment files.

Example:

```bash
mkdir secrets
```

### Build and Start

```bash
make
```

or

```bash
cd srcs
docker-compose up --build
```

### Stop Infrastructure

```bash
make down
```

### Rebuild Infrastructure

```bash
make re
```

---

## Project Structure

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
        └── wordpress/
```

---

## Resources

### Official Documentation

* Docker Documentation
* Docker Compose Documentation
* NGINX Documentation
* MariaDB Documentation
* WordPress Documentation
* PHP-FPM Documentation

### Learning Resources

* Docker Deep Dive — Nigel Poulton
* Docker Networking Documentation
* Docker Volumes Documentation

### AI Usage

AI tools were used as learning and assistance resources during development.

They were used to:

* Understand Docker concepts
* Clarify networking and volume behavior
* Review architecture decisions
* Assist with debugging and troubleshooting
* Improve documentation structure

All generated content was reviewed, tested, and adapted before being included in the project.

