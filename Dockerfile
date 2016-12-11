FROM jenkins

MAINTAINER Christian Gripp <mail@core23.de>

ENV DEBIAN_FRONTEND noninteractive

# Switch to install mode
USER root

# Timezone
ENV TIMEZONE="Europe/Berlin"
RUN echo $TIMEZONE > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# ANT, GIT, PHP
RUN echo 'deb http://packages.dotdeb.org jessie all' > /etc/apt/sources.list.d/dotdeb.list \
  && gpg --keyserver keys.gnupg.net --recv-key 89DF5277 && gpg -a --export 89DF5277 | apt-key add - \
  && apt-get update \
  && apt-get install -y \
	  ant \
	  git \
	  php7.0 php7.0-cli php7.0-curl php-codecoverage php7.0-gd php7.0-geoip php7.0-intl php7.0-json php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-opcache php7.0-readline php7.0-sqlite php7.0-xdebug php7.0-xml php7.0-xsl php7.0-zip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# xdebug config
RUN echo 'xdebug.max_nesting_level = 500' >> /etc/php/7.0/mods-available/xdebug.ini

# Install Composer
RUN wget -O /usr/local/bin/composer.phar https://getcomposer.org/composer.phar && chmod +x /usr/local/bin/composer.phar; \
    cp -R -d /etc/php/7.0/cli /etc/php/7.0/composer; \
    rm /etc/php/7.0/composer/conf.d/20-xdebug.ini; \
    echo 'OLD_SCAN_DIR=$PHP_INI_SCAN_DIR' >> /usr/local/bin/composer; \
    echo 'export PHP_INI_SCAN_DIR=/etc/php/7.0/composer/conf.d' >> /usr/local/bin/composer; \
    echo 'COMPOSER=$(which composer.phar)' >> /usr/local/bin/composer; \
    echo 'php -d memory_limit=-1 $COMPOSER $@' >> /usr/local/bin/composer; \
    echo 'export PHP_INI_SCAN_DIR=$OLD_SCAN_DIR' >> /usr/local/bin/composer; \
    chmod +x /usr/local/bin/composer;


# Switch to normal mode
USER jenkins

ENV PATH /var/composer/bin:$PATH

# Composer dependencies
COPY composer.sh /usr/local/bin/composer.sh
COPY composer.txt /usr/share/jenkins/composer.txt
RUN composer.sh /usr/share/jenkins/composer.txt

# PHPCS config
RUN	phpcs --config-set installed_paths /var/composer/vendor/escapestudios/symfony2-coding-standard;

# Jenkins plugins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN plugins.sh /usr/share/jenkins/plugins.txt
