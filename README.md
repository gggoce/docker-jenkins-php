Jenkins CI with PHP support
===========================

[![Build Status](http://img.shields.io/travis/core23/docker-jenkins-php.svg)](https://travis-ci.org/core23/docker-jenkins-php)

[![Donate to this project using Flattr](https://img.shields.io/badge/flattr-donate-yellow.svg)](https://flattr.com/profile/core23)
[![Donate to this project using PayPal](https://img.shields.io/badge/paypal-donate-yellow.svg)](https://paypal.me/gripp)

Create
------
Create a simple image with the the open port 8080.
```
docker run --name jenkins-php -p 8080:8080 core23/jenkins-php-ci
```

If you want to configure the timezone and map the jenkins directory:
```
docker run --name jenkins-php -p 8080:8080 -v /var/docker/jenkins:/var/jenkins_home -e TIMEZONE=Europe/Berlin core23/jenkins-php-ci
```

Enter
-----
Enter the image an run some commands, e.g. update composer
```
docker exec -it jenkins-php bash
```
