FROM debian:bookworm

RUN apt update && apt install -y vsftpd

RUN mkdir -p /var/run/vsftpd/empty

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

EXPOSE 21 21100-21110

CMD ["/usr/local/bin/init.sh"]
