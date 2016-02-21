Jenkins CI with PHP support
===========================

Create
------
Create a simple image with the the open port 8080.
```
docker run --name jenkins-php -p 8080:8080 core23/jenkins-php-ci
```

If you want to configure the timezone, github token and map the jenkins directory:
```
docker run --name jenkins-php -p 8080:8080 -v /var/docker/jenkins:/var/jenkins_home -e 'TIME_ZONE=Europe/Berlin' -e 'GITHUB_TOKEN=XXXXXXXX' core23/jenkins-php-ci
```


Enter
-----
Enter the image an run some commands, e.g. update composer
```
docker exec -it jenkins-php bash
```


Configure
---------

```
docker run -ti --name jenkins_tmp -v /var/docker/jenkins:/var/jenkins_home core23/jenkins-php-ci bash
```
