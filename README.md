Jenkins CI with PHP support
===========================

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
