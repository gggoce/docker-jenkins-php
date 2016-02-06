FROM jenkins

ENV DEBIAN_FRONTEND noninteractive

MAINTAINER Christian Gripp <mail@core23.de>

# Switch to install mode
USER root

RUN apt-get update \
  && apt-get install -y \
	  ant \
	  git \
	  php5 php5-cli php5-xsl php5-json php5-curl php5-sqlite php5-mysqlnd php5-xdebug php5-intl php5-mcrypt php-codecoverage \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget -O /usr/local/bin/composer https://getcomposer.org/composer.phar && chmod +x /usr/local/bin/composer

RUN	bash -c ' \
		export COMPOSER_BIN_DIR=/var/composer/bin; \
		export COMPOSER_HOME=/var/composer; \
		composer global require "phpunit/phpunit=*" --no-update; \
		composer global require "squizlabs/php_codesniffer=*" --no-update; \
		composer global require "escapestudios/symfony2-coding-standard=*" --no-update; \
		composer global require "phploc/phploc=*" --no-update; \
		composer global require "pdepend/pdepend=*" --no-update; \
		composer global require "phpmd/phpmd=*" --no-update; \
		composer global require "sebastian/phpcpd=*" --no-update; \
		composer global require "theseer/phpdox=*" --no-update; \
		composer global require "fabpot/php-cs-fixer=*" --no-update; \
		composer global update --prefer-source --no-interaction; '; \
	ln -s /var/composer/bin/pdepend /usr/local/bin/; \
	ln -s /var/composer/bin/phpcpd /usr/local/bin/; \
	ln -s /var/composer/bin/phpcs /usr/local/bin/; \
	ln -s /var/composer/bin/phpdox /usr/local/bin/; \
	ln -s /var/composer/bin/phploc /usr/local/bin/; \
	ln -s /var/composer/bin/phpmd /usr/local/bin/; \
	ln -s /var/composer/bin/phpunit /usr/local/bin/; \
	ln -s /var/composer/bin/php-cs-fixer /usr/local/bin/;

RUN	phpcs --config-set installed_paths /var/composer/vendor/escapestudios/symfony2-coding-standard;

RUN echo "xdebug.max_nesting_level = 500" >> /etc/php5/mods-available/xdebug.ini

# Switch to normal mode
USER jenkins

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
