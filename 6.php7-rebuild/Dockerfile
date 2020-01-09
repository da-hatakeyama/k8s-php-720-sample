FROM centos:centos7.2.1511

# remi
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
 && rpm -Uvh https://rpms.remirepo.net/enterprise/remi-release-7.rpm

# normal updates
RUN yum -y update

# php
RUN yum -y install \
  php72 php72-php php72-php-opcache php72-php-bcmath php72-php-cli \
  php72-php-common php72-php-gd php72-php-intl php72-php-json \
  php72-php-mbstring php72-php-pdo php72-php-pdo-dblib \
  php72-php-devel php72-php-pear php72-php-smarty php72-php-pecl-mcrypt \
  php72-php-xmlrpc php72-php-xml php72-php-mysql php72-php-soap \
  php72-php-fpm php72-php-pdo php72-php-pgsql php72-php-pecl-zip \
  php72-php-pecl-mongodb php72-php-pecl-xdebug php72-php-pecl-yaml subversion git \
  ssmtp mailutils gcc-c++ make \
  yum clean all
RUN curl -sL https://rpm.nodesource.com/setup_12.x | bash -
RUN yum install -y nodejs \
  yum clean all
RUN rm -rf /var/lib/apt/lists/*
RUN echo "hostname=mail.example.co.jp" > /etc/ssmtp/ssmtp.conf
RUN echo "root=root@mail.example.co.jp" >> /etc/ssmtp/ssmtp.conf
RUN echo "mailhub=postfix-sv" >> /etc/ssmtp/ssmtp.conf
RUN echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf
RUN echo "localhost localhost.localdomain" >> /etc/hosts

RUN cp /etc/opt/remi/php72/php.ini /etc/opt/remi/php72/php.ini_org
RUN cp /etc/opt/remi/php72/php-fpm.conf /etc/opt/remi/php72/php-fpm.conf_org
RUN cp -RT /etc/opt/remi/php72/php-fpm.d /etc/opt/remi/php72/php-fpm.d_org
ADD ./php.ini /etc/opt/remi/php72/php.ini
ADD ./php-fpm.conf /etc/opt/remi/php72/php-fpm.conf
ADD ./php-fpm.d/ /etc/opt/remi/php72/php-fpm.d
ADD ./dns-regist.sh /usr/local/bin/
RUN chmod 700 /usr/local/bin/dns-regist.sh
RUN chown root:root /usr/local/bin/dns-regist.sh

RUN sed -i "s/;date.timezone =/date.timezone = Asia\/Tokyo/" /etc/opt/remi/php72/php.ini

RUN mkdir -p /var/www/html
RUN useradd www-data
RUN echo 'www-data:www-data' |chpasswd
ENV PATH $PATH:/opt/remi/php72/root/usr/sbin:/opt/remi/php72/root/usr/bin:/usr/local/bin

# 言語を日本語に設定
RUN localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
RUN echo 'LANG="ja_JP.UTF-8"' >  /etc/locale.conf
ENV LANG ja_JP.UTF-8

# 日付を日本語に設定
RUN echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock
RUN rm -f /etc/localtime
RUN ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# svnを認証記憶するよう設定
RUN mkdir ~/.subversion
RUN echo -e "[global]\nstore-passwords = yes\nstore-auth-creds = yes" > ~/.subversion/config

RUN mv /etc/opt/remi/php72/php.d/20-bcmath.ini /etc/opt/remi/php72/php.d/20-bcmath.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-bz2.ini /etc/opt/remi/php72/php.d/20-bz2.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-calendar.ini /etc/opt/remi/php72/php.d/20-calendar.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-ctype.ini /etc/opt/remi/php72/php.d/20-ctype.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-curl.ini /etc/opt/remi/php72/php.d/20-curl.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-dom.ini /etc/opt/remi/php72/php.d/20-dom.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-exif.ini /etc/opt/remi/php72/php.d/20-exif.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-fileinfo.ini /etc/opt/remi/php72/php.d/20-fileinfo.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-ftp.ini /etc/opt/remi/php72/php.d/20-ftp.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-gd.ini /etc/opt/remi/php72/php.d/20-gd.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-gettext.ini /etc/opt/remi/php72/php.d/20-gettext.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-iconv.ini /etc/opt/remi/php72/php.d/20-iconv.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-intl.ini /etc/opt/remi/php72/php.d/20-intl.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-json.ini /etc/opt/remi/php72/php.d/20-json.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-mbstring.ini /etc/opt/remi/php72/php.d/20-mbstring.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-mysqlnd.ini /etc/opt/remi/php72/php.d/20-mysqlnd.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-pdo.ini /etc/opt/remi/php72/php.d/20-pdo.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-pgsql.ini /etc/opt/remi/php72/php.d/20-pgsql.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-phar.ini /etc/opt/remi/php72/php.d/20-phar.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-posix.ini /etc/opt/remi/php72/php.d/20-posix.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-shmop.ini /etc/opt/remi/php72/php.d/20-shmop.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-simplexml.ini /etc/opt/remi/php72/php.d/20-simplexml.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-soap.ini /etc/opt/remi/php72/php.d/20-soap.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-sockets.ini /etc/opt/remi/php72/php.d/20-sockets.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-sqlite3.ini /etc/opt/remi/php72/php.d/20-sqlite3.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-sysvmsg.ini /etc/opt/remi/php72/php.d/20-sysvmsg.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-sysvsem.ini /etc/opt/remi/php72/php.d/20-sysvsem.in_back
RUN mv /etc/opt/remi/php72/php.d/20-sysvshm.ini /etc/opt/remi/php72/php.d/20-sysvshm.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-tokenizer.ini /etc/opt/remi/php72/php.d/20-tokenizer.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-xml.ini /etc/opt/remi/php72/php.d/20-xml.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-xmlwriter.ini /etc/opt/remi/php72/php.d/20-xmlwriter.ini_back
RUN mv /etc/opt/remi/php72/php.d/20-xsl.ini /etc/opt/remi/php72/php.d/20-xsl.ini_back
RUN mv /etc/opt/remi/php72/php.d/30-mcrypt.ini /etc/opt/remi/php72/php.d/30-mcrypt.ini_back
RUN mv /etc/opt/remi/php72/php.d/30-mysqli.ini /etc/opt/remi/php72/php.d/30-mysqli.ini_back
RUN mv /etc/opt/remi/php72/php.d/30-pdo_dblib.ini /etc/opt/remi/php72/php.d/30-pdo_dblib.ini_back
RUN mv /etc/opt/remi/php72/php.d/30-pdo_mysql.ini /etc/opt/remi/php72/php.d/30-pdo_mysql.ini_back
RUN mv /etc/opt/remi/php72/php.d/30-pdo_pgsql.ini /etc/opt/remi/php72/php.d/30-pdo_pgsql.ini_back
RUN mv /etc/opt/remi/php72/php.d/30-pdo_sqlite.ini /etc/opt/remi/php72/php.d/30-pdo_sqlite.ini_back
RUN mv /etc/opt/remi/php72/php.d/30-wddx.ini /etc/opt/remi/php72/php.d/30-wddx.ini_back
RUN mv /etc/opt/remi/php72/php.d/30-xmlreader.ini /etc/opt/remi/php72/php.d/30-xmlreader.ini_back
RUN mv /etc/opt/remi/php72/php.d/30-xmlrpc.ini /etc/opt/remi/php72/php.d/30-xmlrpc.ini_back
RUN mv /etc/opt/remi/php72/php.d/40-yaml.ini /etc/opt/remi/php72/php.d/40-yaml.ini_back
RUN mv /etc/opt/remi/php72/php.d/40-zip.ini /etc/opt/remi/php72/php.d/40-zip.ini_back
RUN mv /etc/opt/remi/php72/php.d/50-mongodb.ini /etc/opt/remi/php72/php.d/50-mongodb.ini_back
RUN mv /etc/opt/remi/php72/php.d/50-mysql.ini /etc/opt/remi/php72/php.d/50-mysql.ini_back

RUN cd /tmp/
RUN curl -s https://getcomposer.org/installer | php
RUN mv -i composer.phar /usr/local/bin/composer

RUN chown root:www-data /opt/remi/php72/root/usr/sbin/php-fpm && \
  chmod 775 /opt/remi/php72/root/usr/sbin/php-fpm && \
  mkdir -p /var/opt/remi/php72 && \
  touch /var/opt/remi/php72/stdout && \
  chown -R root:www-data /var/opt/remi/php72 && \
  chmod -R 775 /var/opt/remi/php72 && \
  mkdir -p /var/log/php7
  #mkdir -p /var/opt/remi/php72/stdout && \
  #chown root:www-data /var/opt/remi/php72/stdout && \
  #chmod 660 /var/opt/remi/php72/stdout && \
  #chown root:www-data /var/opt/remi/php72/run/php-fpm && \
  #chmod 775 /var/opt/remi/php72/run/php-fpm

CMD ["php-fpm"]
