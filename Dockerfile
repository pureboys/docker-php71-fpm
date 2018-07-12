FROM php:7.1.14-fpm
LABEL maintainer="Oliver lin <linbin@smzdm.com>"

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak \
&& { \
echo deb http://mirrors.163.com/debian/ jessie main non-free contrib; \
echo deb http://mirrors.163.com/debian/ jessie-updates main non-free contrib; \
echo deb http://mirrors.163.com/debian/ jessie-backports main non-free contrib; \
echo deb-src http://mirrors.163.com/debian/ jessie main non-free contrib; \
echo deb-src http://mirrors.163.com/debian/ jessie-updates main non-free contrib; \
echo deb-src http://mirrors.163.com/debian/ jessie-backports main non-free contrib; \
echo deb http://mirrors.163.com/debian-security/ jessie/updates main non-free contrib; \
echo deb-src http://mirrors.163.com/debian-security/ jessie/updates main non-free contrib; \
} | tee /etc/apt/sources.list

RUN apt-get update && apt-get upgrade -y \
    g++ \
    libc-client-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpng12-dev \
    libpq-dev \
    libssl-dev \
    libssl-doc \
    libsasl2-dev \
    zlib1g-dev \
    && docker-php-ext-install \
    bz2 \
    iconv \
    mbstring \
    mcrypt \
    mysqli \
    pgsql \
    pdo_mysql \
    pdo_pgsql \
    soap \
    zip \
    && docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && yes '' | pecl install imagick && docker-php-ext-enable imagick \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && pecl install memcached && docker-php-ext-enable memcached \
    && docker-php-ext-configure intl  \
    && docker-php-ext-install intl \
    && pecl install mongodb && docker-php-ext-enable mongodb \
    && pecl install redis && docker-php-ext-enable redis \
    && pecl install xdebug && docker-php-ext-enable xdebug \
    && apt-get autoremove -y --purge \
    && apt-get clean \
    && rm -Rf /tmp/*

COPY ./conf/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf   

WORKDIR /web