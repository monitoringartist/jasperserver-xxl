#!/bin/bash
set -e

setup_jasperserver() {
    JS_DB_TYPE=${JS_DB_TYPE:-mysql}
    JS_DB_HOST=${JS_DB_HOST:-jasper.db}
    JS_DB_USER=${JS_DB_USER:-jasper}
    JS_DB_PASSWORD=${JS_DB_PASSWORD:-my_password}
    JS_DB_PORT=${JS_DB_PORT:-3306}

    pushd ${JASPERSERVER_BUILD}
    cp sample_conf/${JS_DB_TYPE}_master.properties default_master.properties
    sed -i -e "s|^appServerDir.*$|appServerDir = $CATALINA_HOME|g; s|^dbHost.*$|dbHost=$JS_DB_HOST|g; s|^dbUsername.*$|dbUsername=$JS_DB_USER|g; s|^dbPassword.*$|dbPassword=$JS_DB_PASSWORD|g" default_master.properties
    
    # DB seeding
    ./js-ant create-js-db init-js-db-ce import-minimal-ce || true
    for i in $@; do
        ./js-ant $i
    done

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
