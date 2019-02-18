#!/bin/bash

echo " >> Configuring hosts..."
su mirroring_comrade -s /bin/bash -c "mc config host add source ${SOURCE_URL} ${SOURCE_ACCESS_TOKEN} ${SOURCE_SECRET}"
su mirroring_comrade -s /bin/bash -c "mc config host add target ${TARGET_URL} ${TARGET_ACCESS_TOKEN} ${TARGET_SECRET}"

echo " >> Configuring crontab..."
echo "${CRON_SCHEDULE} su mirroring_comrade -s /bin/bash -c /scheduled_mirroring.sh >> /tmp/mirroring.log" > /etc/crontabs/root

echo " >> Starting backgrounded crontab..."
crond

echo " >> Capturing logs"
touch /tmp/mirroring.log
exec tail -f /tmp/mirroring.log
