FROM minio/mc

ENV CRON_SCHEDULE="*/10 * * *" \
    SOURCE_BUCKET=backup \
    SOURCE_URL=http://primary.backups.example.org

COPY ./mirroring_entrypoint.sh /
COPY ./scheduled_mirroring.sh /

RUN apk add --update bash \
    && addgroup -g 1050 mirroring_comrade \
    && adduser -D -u 1050 -G mirroring_comrade mirroring_comrade \
    && chmod +x /mirroring_entrypoint.sh /scheduled_mirroring.sh

ENTRYPOINT "/mirroring_entrypoint.sh"
