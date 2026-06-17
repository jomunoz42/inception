FROM debian:bookworm

RUN apt update && apt install -y curl

RUN curl -L \
https://github.com/amir20/dozzle/releases/download/v8.13.4/dozzle_linux_amd64 \
-o /usr/local/bin/dozzle

RUN chmod +x /usr/local/bin/dozzle

EXPOSE 8082

CMD ["/usr/local/bin/dozzle"]
