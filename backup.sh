#!/bin/sh

VOLUME_SRC=${VOLUME}

NOW=$(date +"%Y%m%d%H%M%S")
TARGET=/backups/backup_${NOW}.tar.gz

tar -czf ${TARGET} ${VOLUME_SRC} 