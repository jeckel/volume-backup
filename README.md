# volume-backup

A docker image to backup docker's volume on periodic


```bash
docker run -it --rm \
	-v /path/to/volume:/project \
	-v `pwd`/backups:/backups \
	jeckel/volume-backup
```