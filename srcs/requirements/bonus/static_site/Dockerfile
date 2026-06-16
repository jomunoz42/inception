FROM debian:bookworm

RUN apt update && apt install -y nginx

COPY website/ /var/www/static/
COPY conf/default.conf /etc/nginx/sites-available/default

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
