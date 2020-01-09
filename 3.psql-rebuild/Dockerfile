# FROM postgres:9.6 # groongaインストール時
FROM postgres:9.2.23
RUN localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
COPY ./sqls/*.sql /docker-entrypoint-initdb.d/
COPY ./creat-volume.sh /usr/local/bin/
RUN chmod 700 /usr/local/bin/creat-volume.sh
RUN chown root:root /usr/local/bin/creat-volume.sh
COPY ./docker-entrypoint.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh
RUN chown root:root /usr/local/bin/docker-entrypoint.sh

RUN apt-get update
RUN apt-get install -y less

# groonga
#RUN apt update
#RUN apt install -y -V apt-transport-https gnupg wget
#RUN echo "deb [signed-by=/usr/share/keyrings/groonga-archive-keyring.gpg] https://packages.groonga.org/debian/ stretch main" > /etc/apt/sources.list.d/groonga.list
#RUN echo "deb-src [signed-by=/usr/share/keyrings/groonga-archive-keyring.gpg] https://packages.groonga.org/debian/ stretch main" >> /etc/apt/sources.list.d/groonga.list
#RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list
#RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
#RUN wget -O /usr/share/keyrings/groonga-archive-keyring.gpg https://packages.groonga.org/debian/groonga-archive-keyring.gpg
#RUN apt update
#RUN apt install -y -V postgresql-9.6-pgroonga
#RUN apt-get install -y -V groonga-tokenizer-mecab

# pg_bigm
#RUN wget 'https://ja.osdn.net/frs/redir.php?m=iij&f=pgbigm%2F66559%2Fpg_bigm-1.1-20161011.tar.gz' -O pg_bigm-1.1.tar.gz
#RUN tar zxvf pg_bigm-1.1.tar.gz
#RUN cd pg_bigm-1.1-20161011/
#RUN apt-get install -y --reinstall build-essentia
#RUN apt install -y build-essential devscripts debhelperl
#RUN make USE_PGXS=1 PG_CONFIG=/usr/bin/pg_config
#RUN make USE_PGXS=1 PG_CONFIG=/usr/bin/pg_config install
