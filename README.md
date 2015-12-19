# alpine-mysql
MySql/MariaDB Docker container based on alpine OS

## To create a docker-machine box
```shell
# creation
docker-machine create --driver virtualbox alpine-mysql
eval "$(docker-machine env alpine-mysql)"

# upgrade (optional)
docker-machine upgrade alpine-mysql
```

## To create the corresponding docker image:
```shell
# build a docker image from the Dockerfile on the file system
docker build -t jpao/mysql:latest .
```

## To test the previous built image:
```shell
# create a dedicated volume (needs docker version >= 1.9)
docker volume create --name mysqldata

# first time run
docker run -d -v mysqldata:/var/lib/mysql --name mysql jpao/mysql:latest /bin/sh -c "chown -R mysql:mysql /var/lib/mysql && mysql_install_db --user=mysql --datadir=/var/lib/mysql && mysqld_safe"

# local mysql client
docker exec -it mysql sh -c "export TERM=xterm && mysql -e 'show databases;'"

+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| test               |
+--------------------+

# stop container
docker stop mysql

# start again (no init this time)
docker start mysql

# grant admin remote access
docker exec -it mysql sh -c "mysql -e 'GRANT ALL ON *.* TO admin@\"%\" IDENTIFIED BY \"mysql\" WITH GRANT OPTION; FLUSH PRIVILEGES'"

# remote access
docker run --rm -it --link mysql jpao/mysql:latest mysql --host mysql --user admin -pmysql

Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 6
Server version: 5.5.46-MariaDB-log MariaDB Server

Copyright (c) 2000, 2015, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]>

...

# again stop container
docker stop mysql

# finally clean
docker rm mysql
docker volume rm mysqldata
```
