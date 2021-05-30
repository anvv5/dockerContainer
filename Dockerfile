FROM debian:buster
LABEL creater="sbudding"

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install nginx default-mysql-server php php-fpm php-mysql php-json php-mbstring \
openssl wordpress vim php7.3

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN mkdir /var/www/ft_server

ADD srcs/startuem.sh .
ADD srcs/userbase .
ADD srcs/index.sh .
RUN chmod 777 index.sh
ADD srcs/wp-config.php /usr/share/wordpress/
ADD srcs/default /etc/nginx/sites-available

ADD https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz phpMyAdmin-5.0.4.tar.gz
RUN tar -xf phpMyAdmin-5.0.4.tar.gz && mv phpMyAdmin-5.0.4-all-languages /var/www/ft_server/phpmyadmin
ADD /srcs/config.inc.php /var/www/ft_server/phpmyadmin

RUN cp -r /usr/share/wordpress/ /var/www/ft_server/
RUN service mysql start && mysql < userbase

RUN openssl req -x509 -nodes -newkey rsa:2048 -days 365 -keyout key.key -out crt.crt \
	-subj '/CN=sbudding'

RUN chown -R www-data:www-data /var/www/ft_server

EXPOSE 80 443

ENTRYPOINT ["bash", "startuem.sh"]