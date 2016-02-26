FROM tomcat:7
MAINTAINER Jan Garaj info@monitoringartist.com

ENV \
  VERSION=6.2.0 \ 
  JS_Xmx=512m \
  JS_MaxPermSize=256m \
  JS_CATALINA_OPTS="-XX:+UseBiasedLocking -XX:BiasedLockingStartupDelay=0 -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+DisableExplicitGC -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:+CMSParallelRemarkEnabled -XX:+UseCompressedOops -XX:+UseCMSInitiatingOccupancyOnly" \
  JS_DB_TYPE=mysql \
  JS_DB_HOST=jasper.db \
  JS_DB_USER=jasper \
  JS_DB_PASSWORD=my_password \
  JASPERSERVER_HOME=/jasperserver \
  JASPERSERVER_BUILD=/jasperserver/buildomatic

RUN \
  apt-get update && \
  apt-get install -y vim && \  
  curl -SL http://sourceforge.net/projects/jasperserver/files/JasperServer/JasperReports%20Server%20Community%20Edition%20${VERSION}/jasperreports-server-cp-${VERSION}-bin.zip -o /tmp/jasperserver.zip && \
  unzip /tmp/jasperserver.zip -d /usr/src/ && \
  mv /usr/src/jasperreports-server-cp-${VERSION}-bin /jasperreports-server && \
  rm -rf /tmp/* && \
  rm -rf /var/lib/apt/lists/* && \
  chmod +x entrypoint.sh

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

CMD ["run"]
