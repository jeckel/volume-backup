#!/bin/bash

readonly NOW=$(date +"%Y%m%d%H%M%S")

if [ -z ${TARGET_DIRECTORY} ]; then
    TARGET_DIRECTORY = /backups
fi

# ----------------------------------------------------------
# Backup a mounted volume
# @usage
#    backup_volume <path_to_backup> <target_folder> [<tar_options>]
#
# @param    path to source folder
# @param    path to target folder
# @param    tar options
function backup_volume() {
    local src=$1
    local targetDir=$2
    local tarOptions=$3
    local target=${targetDir}/backup_$(basename ${src})_$(date +"%Y%m%d%H%M%S").tar.gz
    local uid
    local gid

    cd ${targetDir}
    set -- `ls -nd .` && uid=$3 && gid=$4

    cd ${src}
    tar ${tarOptions} -czf ${target} .
    chown $uid:$gid ${target}
}

# ----------------------------------------------------------
# Cleanup obsolete backup
#
# @param    path to source folder
# @param    path to target folder
# @param    nb backup to keep
function cleanup() {
    local src=$1
    local targetDir=$2
    local backupMask=${targetDir}/backup_$(basename ${src})_*.tar.gz
    local keepHistory=$3

    local target=$2/backup_$(basename ${src})_$(date +"%Y%m%d%H%M%S").tar.gz

    # Keep only the last "$keepHistory" backups
    ls -1dr ${backupMask} | tail -n +$((keepHistory + 1)) | xargs rm -rf
}

# If env variable $SOURCE_DIRECTORIES is not defined, backup all mounted volumes
if [ -z "${SOURCE_DIRECTORIES}" ] ; then
    # Take only docker mounted directories, exclude systems directories (/etc) and the backup directory
    sourceToBackup=( $(mount | grep '^/[^/]' | grep -v /etc | grep -v 'on / ' | grep -v ${TARGET_DIRECTORY} | cut -d\  -f 3) )
else
    IFS=' ' read -r -a sourceToBackup <<< "${SOURCE_DIRECTORIES}"
fi

for source in "${sourceToBackup[@]}"
do
    echo ${source}
    backup_volume ${source} ${TARGET_DIRECTORY} "${TAR_OPTIONS}"

    if [ ! -z ${KEEP_NB_BACKUP} ] ; then
        cleanup ${source} ${TARGET_DIRECTORY} ${KEEP_NB_BACKUP}
    fi
done
