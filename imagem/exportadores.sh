#!/bin/bash
exec /usr/local/bin/apache_exporter --insecure --scrape_uri=http://localhost/server-status --telemetry.address=0.0.0.0:9117 --telemetry.endpoint=/metrics &
mysqlup=1
while [ $mysqlup -ne 0 ]
do 
	nc -z $HOSTDATABASE 3306
	mysqlup=$?
	if [ $mysqlup -eq 0 ]
	then
		exec /usr/local/bin/mysqld_exporter &
	fi
	sleep .5
done

