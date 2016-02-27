#! /bin/bash

# Parse a txt file as specification for composer to be installed
# in the reference directory, so user can define a derived Docker image with just :
#
# FROM core23/jenkins-php-ci
# COPY composer.txt /composer.txt
# RUN /usr/local/bin/composer.sh /composer.txt
#

set -e

export COMPOSER_BIN_DIR=/var/composer/bin
export COMPOSER_HOME=/var/composer

while read spec || [ -n "$spec" ]; do
    module=(${spec//:/ });
    [[ ${module[0]} =~ ^# ]] && continue
    [[ ${module[0]} =~ ^\s*$ ]] && continue
    [[ -z ${module[1]} ]] && module[1]="@stable"

    echo "Downloading ${module[0]}:${module[1]}"
    composer global require "${module[0]}=${module[1]}" --no-update;
done  < $1

composer global update --prefer-source --no-interaction
