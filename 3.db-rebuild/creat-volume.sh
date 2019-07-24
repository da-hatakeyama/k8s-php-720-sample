#!/bin/bash

# ext4の領域作成（ない場合のみ）
if [[ ! -e /mnt/php-apache-psql-data/php-apache-psql-data.img ]]; then
    dd bs=1M count=4096 if=/dev/zero of=/mnt/php-apache-psql-data/php-apache-psql-data.img
    mkfs.ext4 /mnt/php-apache-psql-data/php-apache-psql-data.img
    INIT=true
fi

mkdir -p /var/lib/postgresql/data2
mount -t ext4 -o loop /mnt/php-apache-psql-data/php-apache-psql-data.img /var/lib/postgresql/data2
if [[ $INIT ]]; then
    rm -rf /var/lib/postgresql/data2/*
fi
chown -Rf postgres:postgres /var/lib/postgresql
chmod -R 700 /var/lib/postgresql
/docker-entrypoint.sh postgres
