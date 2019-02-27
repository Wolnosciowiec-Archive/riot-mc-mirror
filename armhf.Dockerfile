FROM balenalib/armv7hf-alpine:3.9

ENV SOURCE_BUCKET=backup \
    SOURCE_URL=http://primary.backups.example.org

COPY ./mirroring_entrypoint.sh /
COPY ./scheduled_mirroring.sh /

RUN [ "cross-build-start" ]
RUN apk add --update bash \
    && addgroup -g 1050 mirroring_comrade \
    && adduser -D -u 1050 -G mirroring_comrade mirroring_comrade \
    && chmod +x /mirroring_entrypoint.sh /scheduled_mirroring.sh \
    && wget https://dl.minio.io/client/mc/release/linux-arm/mc -O /usr/bin/mc \
    && chmod +x /usr/bin/mc
RUN [ "cross-build-end" ]

ENTRYPOINT "/mirroring_entrypoint.sh"
