#!/bin/sh
echo "===agent cleanup.sh==="
cleanup() {
    ALIDIR=${1}
    KEEP_COUNT=${2:-10}
    if [ -d "$ALIDIR" ]; then
        cd "$ALIDIR"
        echo "Handle directory $ALIDIR..."
    else
        echo "Directory $ALIDIR does not exist, skipping."
        return
    fi
    
    if [ $(ls -1 | wc -l) -gt $KEEP_COUNT ]; then
        echo "Found more than $KEEP_COUNT versions. Keeping latest $KEEP_COUNT:"
        ls -t | head -n $KEEP_COUNT
        echo "Deleting old versions:"
        ls -t | tail -n +$((KEEP_COUNT+1)) | xargs rm -rfv
    else
        echo "No cleanup needed (<=$KEEP_COUNT versions)."
    fi
}
stop=0
trap "stop=1" SIGTERM
while [ $stop -eq 0 ]; do
    echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') Clean up old alicloud provider versions..."
    cleanup /cache/plugin-cache/registry.terraform.io/aliyun/alicloud/
    cleanup /cache/plugin-cache/registry.terraform.io/hashicorp/alicloud/
    for i in $(seq 1 300); do
        sleep 2
        [ $stop -eq 1 ] && break
    done
done
