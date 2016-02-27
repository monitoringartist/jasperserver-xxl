# Dockerized TIBCO JasperReports Server Community Edition [![](https://badge.imagelayers.io/monitoringartist/jasperserver-xxl:latest.svg)](https://imagelayers.io/?images=monitoringartist/jasperserver-xxl:latest)

[![Deploy to Docker Cloud](https://files.cloud.docker.com/images/deploy-to-dockercloud.svg)](https://cloud.docker.com/stack/deploy/?repo=https://github.com/monitoringartist/jasperserver-xxl)

Quick start:

```
# Start persistent container storage for database
docker run -d -v /var/lib/mysql --name jasperserver-db-storage busybox:latest

# Start database - MariaDB
docker run \
    -d \
    --name jasperserver-db \
    -v /etc/localtime:/etc/localtime:ro \
    --volumes-from jasperserver-db-storage \
    --env="MARIADB_USER=jasper" \
    --env="MARIADB_PASS=my_password" \
    zabbix/zabbix-db-mariadb:latest

# Start JasperServer    
docker run \
    -d \
    --name jasperserver \
    -p 8080:8080 \
    -v /etc/localtime:/etc/localtime:ro \
    --link jasperserver-db:jasper.db \
    --env="JS_DB_HOST=jasper.db" \
    --env="JS_DB_USER=jasper" \
    --env="JS_DB_PASSWORD=my_password" \
    monitoringartist/jasper-xxl:latest

# Starting and autodeployment can take 5-7 minutes, be patient
# You can watch progres and issuers in logs
docker logs -f jasperserver
```

JasperServer will be available on URL http://<YOUR DOCKER HOST IP>:8080/jasperserver
Default credentials `jasperadmin/jasperadmin`.

Please donate to author, so he can continue to publish other awesome projects 
for free:

[![Paypal donate button](http://jangaraj.com/img/github-donate-button02.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=8LB6J222WRUZ4)

# Configuration

You can use environment variables to configure JasperServer container:

| Environment variable | Default value | Note |
| -------------------- | ------------- | ----- |
| JS_DB_TYPE | mysql | postgres is not supported atm |
| JS_DB_HOST | jasper.db | |
| JS_DB_PORT | 3306 | |
| JS_DB_USER | jasper | |
| JS_DB_PASSWORD | my_password | |
| JS_Xmx | 512m | |
| JS_MaxPermSize | 256m | |
| JS_CATALINA_OPTS | -XX:+UseBiasedLocking -XX:BiasedLockingStartupDelay=0 -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+DisableExplicitGC -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:+CMSParallelRemarkEnabled -XX:+UseCompressedOops -XX:+UseCMSInitiatingOccupancyOnly | |

# Integrations

* [docker-compose for dockerized raintank-collector](https://github.com/monitoringartist/jasperserver-xxl/blob/master/docker-compose.yml)

# Author

[Devops Monitoring zExpert](http://www.jangaraj.com 'DevOps / Docker / Kubernetes / Zabbix / Zenoss / Monitoring'), 
who loves monitoring systems, which start with letter Z. 
Those are Zabbix and Zenoss.

Professional monitoring services:

[![Monitoring Artist](http://monitoringartist.com/img/github-monitoring-artist-logo.jpg)](http://www.monitoringartist.com 'DevOps / Docker / Kubernetes / Zabbix / Zenoss / Monitoring')
