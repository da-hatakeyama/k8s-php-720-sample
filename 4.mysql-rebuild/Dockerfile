FROM mysql:5.6.39

# Set debian default locale to ja_JP.UTF-8
RUN apt-get update && \
    apt-get install -y locales && \
    rm -rf /var/lib/apt/lists/* && \
    echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

# Set MySQL character
RUN { \
    echo '[mysqld]'; \
    echo 'character-set-server=utf8mb4'; \
    echo 'collation-server=utf8mb4_general_ci'; \
    echo '[client]'; \
    echo 'default-character-set=utf8mb4'; \
} > /etc/mysql/conf.d/charset.cnf

COPY ./sqls/*.sql /docker-entrypoint-initdb.d/
COPY ./creat-volume.sh /usr/local/bin/
RUN chmod 700 /usr/local/bin/creat-volume.sh
RUN chown root:root /usr/local/bin/creat-volume.sh
COPY ./docker-entrypoint.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh
RUN chown root:root /usr/local/bin/docker-entrypoint.sh

RUN sed -i "s/#log-error      = \/var\/log\/mysql\/error.log/log-error      = \/var\/log\/mysql\/error.log/" /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo "slow_query_log # slow queryログの有効化" >> /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo "slow_query_log_file=/var/log/mysql/slow.log # ファイルパス" >> /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo "long_query_time=5" >> /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo "log-queries-not-using-indexes" >> /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo "[mysqld]" >> /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo "general_log " >> /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo "general_log_file=/var/log/mysql/general.log" >> /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo "log-bin=master-bin #バイナリログのベース名" >> /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo "log-bin-index=master-bin #バイナリログのファイル名を記録したindexファイル名" >> /etc/mysql/mysql.conf.d/mysqld.cnf

RUN apt-get update
RUN apt-get install -y less
