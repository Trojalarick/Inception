#!/bin/bash

id "ftpuser" &>/dev/null || useradd -m ftpuser

echo "ftpuser:ftppassword" | chpasswd

#  FIX PERMISSIONS
chown -R ftpuser:ftpuser /var/www/html

exec vsftpd /etc/vsftpd.conf