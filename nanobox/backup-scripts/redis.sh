#!/usr/bin/env bash

set -euxo pipefail

# This script should be used to backup your redis component
#
# Following environment variables is needed to be set
#
# AWS_S3_ENDPOINT_URL
#
#     The amazon s3 endpoint
#
# AWS_S3_BACKUP_BUCKET
#
#     The name of the bucket you would like to store the backups in.
#     Example "yourapp/backups"
#
# AWS_ACCESS_KEY_ID
#
#     Access key id
#
# AWS_SECRET_ACCESS_KEY
#
#     Secret access key
#
#
# Example usage:

#     data.redis:
#       image: nanobox/redis
#       extra_packages:
#         - py36-awscli
#       cron:
#         - id: backup
#           schedule: '0 3 * * *'
#           command: curl -fsSL https://raw.githubusercontent.com/standout/Coding/master/nanobox/backup-scripts/redis.sh | bash

date=$(date -u +%Y-%m-%d.%H-%M-%S)
curl -k -H "X-AUTH-TOKEN: ${WAREHOUSE_DATA_HOARDER_TOKEN}" https://${WAREHOUSE_DATA_HOARDER_HOST}:7410/blobs/backup-${HOSTNAME}-${date}.rdb -X POST -T /data/var/db/redis/dump.rdb
aws --endpoint-url ${AWS_S3_ENDPOINT_URL} s3 cp /data/var/db/redis/dump.rdb s3://${AWS_S3_BACKUP_BUCKET}/${APP_NAME}-backup-${HOSTNAME}-${date}.rdb
curl -k -s -H "X-AUTH-TOKEN: ${WAREHOUSE_DATA_HOARDER_TOKEN}" https://${WAREHOUSE_DATA_HOARDER_HOST}:7410/blobs/ |
sed 's/,/\n/g' |
grep ${HOSTNAME} |
sort |
head -n-${BACKUP_COUNT:-5} | # Change the env var BACKUP_COUNT to change how many backups should be saved
sed 's/.*: \?"\(.*\)".*/\1/' |
while read file
do
  curl -k -H "X-AUTH-TOKEN: ${WAREHOUSE_DATA_HOARDER_TOKEN}" https://${WAREHOUSE_DATA_HOARDER_HOST}:7410/blobs/${file} -X DELETE
  aws --endpoint-url ${AWS_S3_ENDPOINT_URL} s3 rm s3://${AWS_S3_BACKUP_BUCKET}/${APP_NAME}-${file}
done
