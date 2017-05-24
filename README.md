[<img src="https://monitoringartist.github.io/managed-by-monitoringartist.png" alt="Managed by Monitoring Artist: DevOps / Docker / Kubernetes / AWS ECS / Zabbix / Zenoss / Terraform / Monitoring" align="right"/>](http://www.monitoringartist.com 'DevOps / Docker / Kubernetes / AWS ECS / Zabbix / Zenoss / Terraform / Monitoring')

# Jasper Server

[![DockerHub pulls](https://img.shields.io/docker/pulls/monitoringartist/jasperserver-xxl.svg?style=plastic&label=DockerHub%20Pulls)](https://img.shields.io/docker/pulls/monitoringartist/jasperserver-xxl.svg)
[![DockerHub stars](https://img.shields.io/docker/stars/monitoringartist/jasperserver-xxl.svg?style=plastic&label=DockerHub%20Stars)](https://img.shields.io/docker/pulls/monitoringartist/jasperserver-xxl.svg)

Dockerized [TIBCO JasperReports Server Community Edition](http://community.jaspersoft.com/download). Quick start:

```
# Start persistent container storage for database
docker run -d -v /var/lib/mysql --name jasperserver-db-storage busybox:latest

# Start database - MariaDB (note: no Zabbix data are included in the Docker image)
docker run \
    --name jasperserver-db \
    -v /etc/localtime:/etc/localtime:ro \
    --volumes-from jasperserver-db-storage \
    --env="MARIADB_USER=jasper" \
    --env="MARIADB_PASS=my_password" \
    -d monitoringartist/zabbix-db-mariadb:latest

# Start JasperServer    
docker run \
    --name jasperserver \
    -p 8080:8080 \
    -v /etc/localtime:/etc/localtime:ro \
    --link jasperserver-db:jasper.db \
    --env="JS_DB_HOST=jasper.db" \
    --env="JS_DB_USER=jasper" \
    --env="JS_DB_PASSWORD=my_password" \
    -d monitoringartist/jasperserver-xxl:latest

# Starting and autodeployment can take 5-7 minutes, be patient
# You can watch progres and issues in logs
docker logs -f jasperserver
```

JasperServer will be available on URL `http://<YOUR DOCKER HOST IP>:8080/jasperserver`.
Default credentials `jasperadmin/jasperadmin`.

Please donate to author, so he can continue to publish other awesome projects 
for free:

[![Paypal donate button](http://jangaraj.com/img/github-donate-button02.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=8LB6J222WRUZ4)

# Configuration

Create a user in your database. The container will create the database if it
does not alrady exist. For PostgreSQL, the user must have the CREATEDB
permission: `ALTER USER jasper CREATEDB`.

You can use environment variables to configure JasperServer container:

| Environment variable | Default value | Note |
| -------------------- | ------------- | ----- |
| JS_DB_TYPE | mysql, postgres | |
| JS_DB_HOST | jasper.db | |
| JS_DB_PORT | mysql: 3306, postgres: 5432 | |
| JS_DB_USER | jasper | |
| JS_DB_PASSWORD | my_password | |
| JS_Xmx | 512m | |
| JS_MaxPermSize | 256m | |
| JS_CATALINA_OPTS | -XX:+UseBiasedLocking -XX:BiasedLockingStartupDelay=0 -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+DisableExplicitGC -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:+CMSParallelRemarkEnabled -XX:+UseCompressedOops -XX:+UseCMSInitiatingOccupancyOnly | |
| JS_DISABLE_CSRFGUARD | false | This disables CSRF Guard, which is necessary when using Jasper Server behind a reverse proxy. |
| JS_ENABLE_SAVE_TO_HOST_FS | false | This allows the scheduled reports to be saved into the local filesystem. You will need to use a Docker volume to be able to see the generate files outside of the container. |
| JS_MAIL_HOST | mail.example.com | |
| JS_MAIL_PORT | 25 | |
| JS_MAIL_PROTOCOL | smtp | |
| JS_MAIL_USERNAME | admin | |
| JS_MAIL_PASSWORD | password | |
| JS_MAIL_SENDER | admin@example.com | |
| JS_WEB_DEPLOYMENT_URI | http://localhost:8080/jasperserver | |

# Integrations

* [docker-compose for dockerized jasperserver-xxl](https://github.com/monitoringartist/jasperserver-xxl/blob/master/docker-compose.yml)

# Author

[Devops Monitoring Expert](http://www.jangaraj.com 'DevOps / Docker / Kubernetes / AWS ECS / Google GCP / Zabbix / Zenoss / Terraform / Monitoring'),
who loves monitoring systems and cutting/bleeding edge technologies: Docker,
Kubernetes, ECS, AWS, Google GCP, Terraform, Lambda, Zabbix, Grafana, Elasticsearch,
Kibana, Prometheus, Sysdig, ...

Summary:
* 1000+ [GitHub](https://github.com/monitoringartist/) stars
* 6000+ [Grafana dashboard](https://grafana.net/monitoringartist) downloads
* 800 000+ [Docker image](https://hub.docker.com/u/monitoringartist/) pulls

Professional devops / monitoring / consulting services:

[![Monitoring Artist](http://monitoringartist.com/img/github-monitoring-artist-logo.jpg)](http://www.monitoringartist.com 'DevOps / Docker / Kubernetes / AWS ECS / Google GCP / Zabbix / Zenoss / Terraform / Monitoring')
