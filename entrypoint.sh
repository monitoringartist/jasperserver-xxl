#!/bin/bash
set -e

setup_jasperserver() {
    JS_DB_TYPE=${JS_DB_TYPE:-mysql}
    # Allow either postgres or postgresql
    [ "$JS_DB_TYPE" = "postgres" ] && JS_DB_TYPE=postgresql
    JS_DB_HOST=${JS_DB_HOST:-jasper.db}
    JS_DB_USER=${JS_DB_USER:-jasper}
    JS_DB_PASSWORD=${JS_DB_PASSWORD:-my_password}
    # Choose the correct default port
    dfl=3306
    [ "$JS_DB_TYPE" = "postgresql" ] && dfl=5432
    JS_DB_PORT=${JS_DB_PORT:-$dfl}
    JS_ENABLE_SAVE_TO_HOST_FS=${JS_ENABLE_SAVE_TO_HOST_FS:-false}
    pushd ${JASPERSERVER_BUILD}
    cp sample_conf/${JS_DB_TYPE}_master.properties default_master.properties
    sed -i -e "s|^appServerDir.*$|appServerDir = $CATALINA_HOME|g; s|^dbHost.*$|dbHost=$JS_DB_HOST|g; s|^dbUsername.*$|dbUsername=$JS_DB_USER|g; s|^dbPassword.*$|dbPassword=$JS_DB_PASSWORD|g" default_master.properties
    
    JS_MAIL_HOST=${JS_MAIL_HOST:-mail.example.com}
    JS_MAIL_PORT=${JS_MAIL_PORT:-25}
    JS_MAIL_PROTOCOL=${JS_MAIL_PROTOCOL:-smtp}
    JS_MAIL_USERNAME=${JS_MAIL_USERNAME:-admin}
    JS_MAIL_PASSWORD=${JS_MAIL_PASSWORD:-password}
    JS_MAIL_SENDER=${JS_MAIL_SENDER:-admin@example.com}
    JS_MAIL_AUTH=${JS_MAIL_AUTH:-false}
    JS_MAIL_TLS=${JS_MAIL_TLS:-false}
    JS_WEB_DEPLOYMENT_URI=${JS_WEB_DEPLOYMENT_URI:-http://localhost:8080/jasperserver}

    sed -i -e "s|^# quartz\.mail\.sender\.host.*$|quartz.mail.sender.host = $JS_MAIL_HOST|g; s|^# quartz\.mail\.sender\.port.*$|quartz.mail.sender.port = $JS_MAIL_PORT|g; s|^# quartz\.mail\.sender\.protocol.*$|quartz.mail.sender.protocol = $JS_MAIL_PROTOCOL|g; s|^# quartz\.mail\.sender\.username.*$|quartz.mail.sender.username = $JS_MAIL_USERNAME|g; s|^# quartz\.mail\.sender\.password.*$|quartz.mail.sender.password = $JS_MAIL_PASSWORD|g; s|^# quartz\.mail\.sender\.from.*$|quartz.mail.sender.from = $JS_MAIL_SENDER|g; s|^# quartz\.web\.deployment\.uri.*$|quartz.web.deployment.uri = $JS_WEB_DEPLOYMENT_URI|g" default_master.properties

    if [ "${JS_MAIL_AUTH}" = "true" ]; then
        # Change the value of mail.smtp.auth to true
        sed -i "s/\(<prop key=\"mail.smtp.auth\">\).*\(<\/prop>\)/\1${JS_MAIL_AUTH}\2/" /usr/local/tomcat/webapps/jasperserver/WEB-INF/applicationContext-report-scheduling.xml
    fi

    if [ "${JS_MAIL_TLS}" = "true" ]; then
        # Add mail.smtp.starttls.enable after mail.smtp.sendpartial
        sed -i "/<prop key=\"mail.smtp.sendpartial\">true<\/prop>/a <prop key=\"mail.smtp.starttls.enable\">true<\/prop>" /usr/local/tomcat/webapps/jasperserver/WEB-INF/applicationContext-report-scheduling.xml
    fi

    # DB seeding
    ./js-ant create-js-db init-js-db-ce import-minimal-ce || true
    for i in $@; do
        ./js-ant $i
    done

    if [ "${JS_ENABLE_SAVE_TO_HOST_FS}" = "true" ]; then
    	# Change the value of enableSaveToHostFS to true
    	sed -i "s/\(<property name=\"enableSaveToHostFS\" value=\"\).*\(\"\/>\)/\1${JS_ENABLE_SAVE_TO_HOST_FS}\2/" /usr/local/tomcat/webapps/jasperserver/WEB-INF/applicationContext.xml
    fi
    
    popd
}

run_jasperserver() {
    if [ ! -d "$CATALINA_HOME/webapps/jasperserver" ]; then
        setup_jasperserver deploy-webapp-ce
    fi
    
    catalina.sh run
}

function wait_db() {    
  echo -n "-----> waiting for database on $JS_DB_HOST:$JS_DB_PORT ..."
  while ! nc -w 1 $JS_DB_HOST $JS_DB_PORT 2>/dev/null
  do
    echo -n .
    sleep 1
  done

  echo '[OK]'
}

export CATALINA_OPTS="-Xmx${JS_Xmx} -XX:MaxPermSize=${JS_MaxPermSize} ${JS_CATALINA_OPTS}"
case "$1" in
    run)
        shift 1
        run_jasperserver "$@"
        ;;
    *)
        exec "$@"
esac
