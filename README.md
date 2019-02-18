riot-mc-mirror
==============
Scheduled minio mirroring (using Minio Client mirror option + crontab)


# QA
Q: Why additional container, not directly `minio/mc`?
A: For following reasons:
- Easily use crontab
- Configure mc connection easily with environment variables

Example usage
-------------

```yaml
version: "2"
services:
    mirroring_comrade:
        image: wolnosciowiec/riot-mc-mirror
        environment:
            # when (in crontab syntax)
            - CRON_SCHEDULE="*/10 * * *"
            - MIRROR_OPTS=--debug  # optional Minio Client options

            - SOURCE_URL=http://primary.backups.example.org
            - SOURCE_BUCKET=backup
            - SOURCE_ACCESS_TOKEN=123
            - SOURCE_SECRET=456

            - TARGET_URL=http://replica-1.backups.example.org
            - TARGET_BUCKET=backup
            - TARGET_ACCESS_TOKEN=123
            - TARGET_SECRET=456
```
