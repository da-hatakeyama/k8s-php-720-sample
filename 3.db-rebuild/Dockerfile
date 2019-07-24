FROM postgres:9.2.23
RUN localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
COPY ./sqls/*.sql /docker-entrypoint-initdb.d/
COPY ./creat-volume.sh /usr/local/bin/
RUN chmod 700 /usr/local/bin/creat-volume.sh
RUN chown root:root /usr/local/bin/creat-volume.sh
