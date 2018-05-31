[![](https://images.microbadger.com/badges/image/jeckel/volume-backup.svg)](https://microbadger.com/images/jeckel/volume-backup "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/jeckel/volume-backup.svg)](https://microbadger.com/images/jeckel/volume-backup "Get your own version badge on microbadger.com") [![Twitter](https://img.shields.io/badge/Twitter-%40jeckel4-blue.svg)](https://twitter.com/intent/user?screen_name=jeckel4) [![LinkedIn](https://img.shields.io/badge/LinkedIn-Julien%20Mercier-blue.svg)](https://www.linkedin.com/in/jeckel/)


# Volume Backup with cron

A docker image to backup docker's volume on specific schedules using cron (or on demand backup)

## Usage

There are two ways to run this tool.
- run as daemon and backup volumes on schedules
- run as one time backup

**Examples**

* **Backup all mounted volumes on daily basis**

```shell
docker run -d --rm \
	-v /path/to/volume:/project \
    -v /path/to/other/volume:/other_project \
	-v `pwd`/backups:/backups \
    -e SCHEDULE="daily"
	jeckel/volume-backup
```

This will use the backups folder as a target. And the mounted folder's name is used as a basename for the backup file.

For example, using the option `-v /path/to/volume:/project` will backup the volume folder into a tar.gz file called `backup_project_<datetime>.tar.gz`

* **Make a one time backup**

```shell
docker run -it --rm \
    -v /path/to/volume:/project \
    -v /path/to/other/volume:/other_project \
    -v `pwd`/backups:/backups \
    jeckel/volume-backup
    backup.sh
```

## Environments

Some environment variable has default value, so you needn't set all of them in most cases.

* `SCHEDULE`: Schedule of backups, default is `"daily"`
* `TARGET_DIRECTORY`: Folder in which backups will be stored, default is `/backups` (it should be a persistent volume of some sort)
* `SOURCE_DIRECTORIES`: Specify which directories will be backups, if not specified all mounted volumes will be backup. You can specify multiple volume by seperating them with a space (`SOURCE_DIRECTORIS=/var/source /var/project` ) 
* `TAR_OPTIONS`: Additional options you want to add to the tar command (like exclude some directories)
* `KEEP_NB_BACKUP`: If defined, only the last `x` backups will be kept, other backup will be deleted. If not specified, no backups are deleted by this script. 

## Schedule syntax:

* `"hourly"`: 0 minute every hour.
* `"daily"`: 02:00 every day.
* `"weekly"`: 03:00 on Sunday every week.
* `"monthly"`: 05:00 on 1st every month.
* `"0 5 * * 6"`: crontab syntax.

## Example

You can look at the [test docker-compose.yml file](tests/docker-compose.yml) to see some examples.

## License
Released under the MIT License.

Copyright Julien MERCIER https://github.com/jeckel