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

# postgreSQL起動
/docker-entrypoint.sh postgres &

# postgresql.conf設定
sleep 10
sed -i "s/\#log_destination = 'stderr'.*/log_destination \= 'stderr'             \# Valid values are combinations of/" /var/lib/postgresql/data2/postgresql.conf
sed -i "s/\#logging_collector \= off.*/logging_collector \= on                \# Enable capturing of stderr and csvlog/" /var/lib/postgresql/data2/postgresql.conf
sed -i "s/\#log_statement = 'none'.*/log_statement = 'all'                 \# none, ddl, mod, all/" /var/lib/postgresql/data2/postgresql.conf


# postgreSQL再起動
ps aux | grep postgres | grep -v grep | awk '{ print "kill -9", $2 }' | sh
/docker-entrypoint.sh postgres
