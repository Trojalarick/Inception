FROM debian:trixie

RUN apt-get update && apt-get install -y vsftpd \
    && rm -rf /var/lib/apt/lists/*

COPY vsftpd.conf /etc/vsftpd.conf
COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 21

CMD ["/start.sh"]
