FROM centos:centos7.2.1511

# normal updates
RUN yum -y update

# remi
RUN yum -y install centos-release-scl && \
  yum clean all

# httpd24
RUN yum -y install httpd24 httpd24-mod_proxy_html httpd24-mod_session httpd24-mod_ssl subversion && \
  scl enable httpd24 bash && \
  yum clean all

RUN cp /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf_org

# Copy apache vhost file to proxy php requests to php-fpm container

RUN mkdir -p /opt/rh/httpd24/root/etc/httpd/Includes
COPY ./Includes /opt/rh/httpd24/root/etc/httpd/Includes

# SSL通信する際はここを有効にする
# RUN mkdir -p /etc/httpd/ssl
# COPY ./ssl /etc/httpd/ssl


RUN sed -i "s/    DirectoryIndex index.html/    DirectoryIndex index.php/" /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf
RUN sed -i "s/#ServerName www.example.com:80/ServerName localhost:80/" /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf
RUN sed -i "s/Listen 80/Listen 80\nListen 10080/" /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf

RUN echo "# クリックジャッキング対策" >> /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf
RUN echo "Header always append X-Frame-Options SAMEORIGIN" \
    >> /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf

RUN echo "# XSS対策" >> /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf
RUN echo "Header set X-XSS-Protection '1; mode=block'" \
    >> /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf
RUN echo "Header set X-Content-Type-Options nosniff" \
    >> /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf

RUN echo "Include Includes/*.conf" \
    >> /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf

RUN mkdir -p /var/www/html
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/rh/httpd24/root/usr/lib64
ENV PATH $PATH:/opt/rh/httpd24/root/usr/sbin


# 言語を日本語に設定
RUN localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
RUN echo 'LANG="ja_JP.UTF-8"' >  /etc/locale.conf
ENV LANG ja_JP.UTF-8

# 日付を日本語に設定
RUN echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock
RUN rm -f /etc/localtime
RUN ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
