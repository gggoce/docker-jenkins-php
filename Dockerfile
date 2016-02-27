FROM jenkins

ENV DEBIAN_FRONTEND noninteractive

MAINTAINER Christian Gripp <mail@core23.de>

# Switch to install mode
USER root

RUN apt-get update \
  && apt-get install -y \
	  ant \
	  git \
	  php5 php5-cli php5-xsl php5-json php5-curl php5-sqlite php5-mysqlnd php5-xdebug php5-gd php5-intl php5-mcrypt php-codecoverage \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget -O /usr/local/bin/composer https://getcomposer.org/composer.phar && chmod +x /usr/local/bin/composer

ENV PATH /var/composer/bin:$PATH

COPY composer.sh /usr/local/bin/composer.sh
COPY composer.txt /usr/share/jenkins/composer.txt

RUN composer.sh /usr/share/jenkins/composer.txt

RUN	phpcs --config-set installed_paths /var/composer/vendor/escapestudios/symfony2-coding-standard;

RUN echo "xdebug.max_nesting_level = 500" >> /etc/php5/mods-available/xdebug.ini

# Switch to normal mode
USER jenkins

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
