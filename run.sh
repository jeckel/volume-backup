#!/bin.sh

BACKUP_SCHEDULE=${SCHEDULE:-daily}

case $BACKUP_SCHEDULE in
	hourly)
		cp /usr/local/bin/backup.sh /etc/periodic/hourly
		;;
	daily)
		cp /usr/local/bin/backup.sh /etc/periodic/daily
		;;
	weekly)
		cp /usr/local/bin/backup.sh /etc/periodic/weekly
		;;
	*)
		echo "$BACKUP_SCHEDULE /usr/local/bin/backup.sh" >> /etc/crontabs/root
		;;
esac

exec /usr/sbin/crond -f -L /var/log/crond.log
