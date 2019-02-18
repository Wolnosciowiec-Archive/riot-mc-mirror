#!/bin/bash

# make sure the destination bucket exists
mc mb target/${TARGET_BUCKET} 2> /dev/null

if ps aux | grep "mc mirror" | grep -v "grep" > /dev/null; then
    echo " >> Synchronization is already running, cannot run twice, cancelling."
    ps aux

    exit 1
fi

echo " >> Starting synchronization - $(date)"

# simply. synchronize.
exec /bin/bash -c "mc mirror ${MIRROR_OPTS} source/${SOURCE_BUCKET} target/${TARGET_BUCKET}"
