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
* `VOLUME` : Specify which mounted volume to backup, is not defined, all mounted volumes (except `/backups`) will be backup
* `DUMP_DEBUG` : If set to `"true"` then show verbose infos, default is `"false"`

## Schedule syntax:

* `"hourly"`: 0 minute every hour.
* `"daily"`: 02:00 every day.
* `"weekly"`: 03:00 on Sunday every week.
* `"monthly"`: 05:00 on 1st every month.
* `"0 5 * * 6"`: crontab syntax.

## Example in `docker-compose` with Wordpress

```yml
version: '2'
services:
  wordpress:
    image: wordpress
    depends_on:
      - mysql
    ports:
      - 8080:80
    environment:
      - WORDPRESS_DB_PASSWORD=wordpress
  mysql:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=wordpress
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - MYSQL_PASSWORD=wordpress
  backup:
    image: jeckel/volume-backup
    depends_on:
      - wordpress
      - mysql
    volumes:
      - ../backups:/backups
    volumes_from:
      - wordpress
      - mysql
```

This docker-compose file show how to configure the backup.

You can start the wordpress site with this command :

```shell
docker-compose up
```

It will start MySQL, Wordpress, and the Backup container with daily backup already scheduled.

You can then trigger an on-demand backup with this line :

```shell
docker-compose exec backup backup.sh
```


## License
Released under the MIT License.

Copyright Julien MERCIER https://github.com/jeckel