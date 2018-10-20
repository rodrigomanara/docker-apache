FROM php:7.1-apache 

RUN apt-get -y update --fix-missing
RUN apt-get upgrade -y
RUN apt-get install cron -y
# Install important libraries
RUN apt-get -y install --fix-missing apt-utils build-essential git curl libcurl3 libcurl3-dev zip

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Other PHP7 Extensions
RUN apt-get -y install libmcrypt-dev
RUN docker-php-ext-install mcrypt

RUN apt-get -y install libsqlite3-dev libsqlite3-0 mysql-client
RUN docker-php-ext-install pdo_mysql 
RUN docker-php-ext-install pdo_sqlite
RUN docker-php-ext-install mysqli

RUN docker-php-ext-install curl
RUN docker-php-ext-install tokenizer
RUN docker-php-ext-install json

RUN apt-get -y install zlib1g-dev
RUN docker-php-ext-install zip

RUN apt-get -y install libicu-dev
RUN docker-php-ext-install -j$(nproc) intl

RUN docker-php-ext-install mbstring
#RUN docker-php-ext-install xsl
RUN apt-get install -y libxslt-dev
RUN docker-php-ext-install xsl
#RUN docker-php-ext-install soap
RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install soap
RUN docker-php-ext-install bcmath

RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ 
RUN docker-php-ext-install -j$(nproc) gd

RUN a2enmod rewrite 

run service apache2 restart

# Set file permissions
RUN chmod -R 777 /var/www /var/www/.* \
  && chown -R www-data:www-data /var/www /var/www/.* \
  && usermod -u 1000 www-data \
  && chsh -s /bin/bash www-data