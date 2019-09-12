#!/usr/bin/env bash

set -euxo pipefail

# This script should be used to backup your storage component
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
#
#     data.storage:
#       image: nanobox/unfs:0.9
#       extra_packages:
#         - py36-awscli
#       cron:
#         - id: backup
#           schedule: '0 3 * * *'
#           command: curl -fsSL https://raw.githubusercontent.com/standout/Coding/master/nanobox/backup-scripts/unfs.sh | bash

date=$(date -u +%Y-%m-%d.%H-%M-%S) ;
(
tar cz -C /data/var/db/unfs/ . |
  tee >(cat - >&4) |
  curl -k -H "X-AUTH-TOKEN: ${WAREHOUSE_DATA_HOARDER_TOKEN}" https://${WAREHOUSE_DATA_HOARDER_HOST}:7410/blobs/backup-${HOSTNAME}-${date}.tgz --data-binary @- >&2
) 4>&1 |
  aws --endpoint-url ${AWS_S3_ENDPOINT_URL} s3 cp - s3://${AWS_S3_BACKUP_BUCKET}/${APP_NAME}-backup-${HOSTNAME}-${date}.tgz ;
curl -k -s -H "X-AUTH-TOKEN: ${WAREHOUSE_DATA_HOARDER_TOKEN}" https://${WAREHOUSE_DATA_HOARDER_HOST}:7410/blobs/ |
  ruby -e "require 'json'; json = JSON.parse(gets); puts JSON.pretty_generate(json)" | # This is a replacement for json_pp
  grep ${HOSTNAME} |
  sort |
  head -n-${BACKUP_COUNT:-10} | # Change the env var BACKUP_COUNT to change how many backups should be saved
  sed 's/.*: "\(.*\)".*/\1/' |
  while read file
  do
    curl -k -H "X-AUTH-TOKEN: ${WAREHOUSE_DATA_HOARDER_TOKEN}" https://${WAREHOUSE_DATA_HOARDER_HOST}:7410/blobs/${file} -X DELETE
    aws --endpoint-url ${AWS_S3_ENDPOINT_URL} s3 rm s3://${AWS_S3_BACKUP_BUCKET}/${APP_NAME}-${file}
  done
