#!/bin/bash

readonly BACKUP_TARGET_DIRECTORY=/backups

NOW=$(date +"%Y%m%d%H%M%S")

VOLUMES_TO_BACKUP=( $(mount | grep ext4 | grep -v /etc | grep -v ${BACKUP_TARGET_DIRECTORY} | cut -d\  -f 3) )

TARGET=/backups/backup_${NOW}.tar.gz

# Retrieve local user UID and group GID
cd /backups/
set -- `ls -nd .` && LOCAL_UID=$3 && LOCAL_GID=$4

for VOLUME in "${VOLUMES_TO_BACKUP[@]}"
do
    printf "Backup volume : ${VOLUME} ... "
	TARGET=/backups/backup_$(basename ${VOLUME})_${NOW}.tar.gz
   	cd $(dirname ${VOLUME})
    tar -czf ${TARGET} $(basename ${VOLUME})
    chown $LOCAL_UID:$LOCAL_GID ${TARGET}
    printf "Done\n"
done
