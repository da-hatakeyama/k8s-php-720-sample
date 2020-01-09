#!/bin/bash

# ext4の領域作成（ない場合のみ）
if [[ ! -e /mnt/php-apache-psql-data/php-apache-mysql-data.img ]]; then
    dd bs=1M count=4096 if=/dev/zero of=/mnt/php-apache-psql-data/php-apache-mysql-data.img
    mkfs.ext4 /mnt/php-apache-psql-data/php-apache-mysql-data.img
    INIT=true
fi

mkdir -p /var/lib/mysql
mount -t ext4 -o loop /mnt/php-apache-psql-data/php-apache-mysql-data.img /var/lib/mysql
if [[ $INIT ]]; then
    rm -rf /var/lib/mysql/*
fi
/usr/local/bin/docker-entrypoint.sh mysqld --datadir /docker-entrypoint-initdb.d --user root
