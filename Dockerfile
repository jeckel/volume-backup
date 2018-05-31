FROM alpine:3.5
LABEL maintainer="Julien Mercier <julien@jeckel-lab.fr>"

ENV TARGET_DIRECTORY=/backups

RUN apk add --update bash && rm -rf /var/cache/apk/*

COPY ./run.sh /usr/local/bin/run.sh
COPY ./backup.sh /usr/local/bin/backup.sh

CMD ["sh", "/usr/local/bin/run.sh"]