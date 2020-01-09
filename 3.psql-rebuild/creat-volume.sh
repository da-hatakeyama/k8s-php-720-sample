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
if [[ -e /var/log/postgresql/docker-entrypoint.log ]]; then
    rm -rf /var/log/postgresql/docker-entrypoint.log
fi
/docker-entrypoint.sh postgres > /var/log/postgresql/docker-entrypoint.log 2>&1 &
# postgresql.conf設定
while :
do
    sleep 5
    psql_init_msg=$(cat /var/log/postgresql/docker-entrypoint.log | grep -c "PostgreSQL init process complete")
    count=`ps -ef | grep postgres | grep -v grep | wc -l`
    echo "psql_init_msg : $psql_init_msg"
    echo "count : $count"
    if [ 0 -lt $count ] && [ 0 -lt $psql_init_msg ]; then
        break
    fi
done
sed -i "s/\#log_destination = 'stderr'.*/log_destination \= 'stderr'             \# Valid values are combinations of/" /var/lib/postgresql/data2/postgresql.conf
sed -i "s/\#logging_collector \= off.*/logging_collector \= on                \# Enable capturing of stderr and csvlog/" /var/lib/postgresql/data2/postgresql.conf
sed -i "s/\#log_statement = 'none'.*/log_statement = 'all'                 \# none, ddl, mod, all/" /var/lib/postgresql/data2/postgresql.conf
sed -i "s/\#log_min_duration_statement = -1.*\# -1 is disabled, 0 logs all statements/log_min_duration_statement = 0        \# -1 is disabled, 0 logs all statements/" /var/lib/postgresql/data2/postgresql.conf
# echo "shared_preload_libraries = 'pg_bigm'" >> /var/lib/postgresql/data2/postgresql.conf

# サポートサイトパフォーマンス問題調査の為のデバッグ
# sed -i "s/max_connections = 100.*/max_connections = 1                   \# \(change requires restart\)/" /var/lib/postgresql/data2/postgresql.conf
# sed -i "s/#superuser_reserved_connections = 3.*/superuser_reserved_connections = 0     \# \(change requires restart\)/" /var/lib/postgresql/data2/postgresql.conf

# postgreSQL再起動
ps aux | grep postgres | grep -v grep | awk '{ print "kill -9", $2 }' | sh
/docker-entrypoint.sh postgres
