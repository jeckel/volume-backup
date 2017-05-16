#!/bin/bash

readonly BACKUP_TARGET_DIRECTORY=/backups

NOW=$(date +"%Y%m%d%H%M%S")

VOLUMES_TO_BACKUP=( $(mount | grep ext4 | grep -v /etc | grep -v ${BACKUP_TARGET_DIRECTORY} | cut -d\  -f 3) )

TARGET=/backups/backup_${NOW}.tar.gz


for VOLUME in "${VOLUMES_TO_BACKUP[@]}"
do
	TARGET=/backups/backup_$(basename ${VOLUME})_${NOW}.tar.gz
   	cd $(dirname ${VOLUME})
   	tar -czf ${TARGET} $(basename ${VOLUME})
done
