#!/bin/bash

useradd -m ftpuser

echo "ftpuser:ftppassword" | chpasswd

mkdir -p /home/ftpuser/ftp
chown -R ftpuser:ftpuser /home/ftpuser

exec vsftpd /etc/vsftpd.conf
