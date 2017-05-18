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
* `VOLUME` : Specify which mounted volume to backup, is not defined, all mounted volumes (except `/backups`) will be backup
* `DUMP_DEBUG` : If set to `"true"` then show verbose infos, default is `"false"`

## Schedule syntax:

* `"hourly"`: 0 minute every hour.
* `"daily"`: 02:00 every day.
* `"weekly"`: 03:00 on Sunday every week.
* `"monthly"`: 05:00 on 1st every month.
* `"0 5 * * 6"`: crontab syntax.


## License
Released under the MIT License.

Copyright Julien MERCIER https://github.com/jeckel