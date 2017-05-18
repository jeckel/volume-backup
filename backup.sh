#!/bin/bash

readonly BACKUP_TARGET_DIRECTORY=/backups
readonly NOW=$(date +"%Y%m%d%H%M%S")

# Retrieve local user UID and group GID
cd ${BACKUP_TARGET_DIRECTORY}
set -- `ls -nd .` && LOCAL_UID=$3 && LOCAL_GID=$4


function backup_volume() {
    local SRC=$1
    local TARGET_FILE=backup_$(basename ${SRC})_${NOW}.tar.gz
    local TARGET=${BACKUP_TARGET_DIRECTORY}/${TARGET_FILE}

    printf "Backup volume '$SRC' : "

    cd $(dirname ${SRC})
    tar -czf ${TARGET} $(basename ${SRC})
    chown $LOCAL_UID:$LOCAL_GID ${TARGET}

    printf "Done (${TARGET_FILE})\n"
}


VOLUMES_TO_BACKUP=( $(mount | grep ext4 | grep -v /etc | grep -v ${BACKUP_TARGET_DIRECTORY} | cut -d\  -f 3) )
for VOLUME in "${VOLUMES_TO_BACKUP[@]}"
do
    backup_volume $VOLUME
done
