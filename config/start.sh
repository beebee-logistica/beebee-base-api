#!/bin/sh

# Tweak nginx to match the workers to cpu's
procs=$(cat /proc/cpuinfo | grep processor | wc -l)
sed -i -e "s/worker_processes 5/worker_processes $procs/" /etc/nginx/nginx.conf

# Uncomment and set variables
sed -i -e "s/;newrelic.enabled = .*/newrelic.enabled = true/" /etc/php7/conf.d/newrelic.ini
sed -i -e "s/;newrelic.loglevel = .*/newrelic.loglevel = \"${NEWRELIC_LOG_LEVEL}\"/" /etc/php7/conf.d/newrelic.ini
sed -i -e "s/;newrelic.daemon.loglevel = .*/newrelic.daemon.loglevel = \"${NEWRELIC_DAEMON_LOG_LEVEL}\"/" /etc/php7/conf.d/newrelic.ini

# New Relic config
if [ "${NEWRELIC}" = "true" ]; then
	# Configure New Relic
	sed -i -e "s/newrelic.enabled = .*/newrelic.enabled = true/" /etc/php7/conf.d/newrelic.ini
	sed -i -e "s/newrelic.appname = .*/newrelic.appname = \"${NEWRELIC_APP_NAME}\"/" /etc/php7/conf.d/newrelic.ini
	sed -i -e "s/newrelic.license = .*/newrelic.license = \"${NEWRELIC_LICENSE}\"/" /etc/php7/conf.d/newrelic.ini
	sed -i -e "s/newrelic.loglevel = .*/newrelic.loglevel = \"${NEWRELIC_LOG_LEVEL}\"/" /etc/php7/conf.d/newrelic.ini
	sed -i -e "s/newrelic.logfile = .*/newrelic.logfile = \"\/dev\/stdout\"/" /etc/php7/conf.d/newrelic.ini
	sed -i -e "s/newrelic.daemon.loglevel = .*/newrelic.daemon.loglevel = \"${NEWRELIC_DAEMON_LOG_LEVEL}\"/" /etc/php7/conf.d/newrelic.ini
	sed -i -e "s/newrelic.daemon.logfile = .*/newrelic.daemon.logfile = \"\/dev\/stdout\"/" /etc/php7/conf.d/newrelic.ini
else
	# Disable New Relic
	sed -i -e "s/newrelic.enabled = .*/newrelic.enabled = false/" /etc/php7/conf.d/newrelic.ini
fi;

# Start supervisord and services
exec supervisord -c /etc/supervisord.conf
