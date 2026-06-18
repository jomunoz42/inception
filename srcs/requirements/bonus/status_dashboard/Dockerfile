FROM debian:bookworm

RUN apt update && apt install -y nginx

COPY website/ /var/www/html/
COPY conf/default.conf /etc/nginx/sites-available/default

EXPOSE 8082

CMD ["nginx", "-g", "daemon off;"]
