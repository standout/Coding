#!/usr/bin/env bash

set -euxo pipefail

# This script should be used to backup your mysql 5 database
#
# Following environment variables is needed to be set
#
# DATABASE_NAME
#
#     The database you would like to backup
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
#     data.db:
#       image: nanobox/mysql:5.6
#       extra_packages:
#         - py36-awscli
#       cron:
#         - id: backup
#           schedule: '0 3 * * *'
#           command: curl -fsSL https://raw.githubusercontent.com/standout/Coding/master/nanobox/backup-scripts/mysql5.sh | DATABASE_NAME=foobar bash

date=$(date -u +%Y-%m-%d.%H-%M-%S)
(
mysqldump --disable-keys --hex-blob -u ${DATA_DB_USER} -p"${DATA_DB_PASS}" --databases ${DATABASE_NAME} |
  gzip |
  tee >(cat - >&4) |
  curl -k -H "X-AUTH-TOKEN: ${WAREHOUSE_DATA_HOARDER_TOKEN}" https://${WAREHOUSE_DATA_HOARDER_HOST}:7410/blobs/backup-${HOSTNAME}-${date}.sql.gz -X POST -T - >&2
) 4>&1 |
  aws s3 cp - s3://${AWS_S3_BACKUP_BUCKET}/${APP_NAME}-backup-${HOSTNAME}-${date}.sql.gz
curl -k -s -H "X-AUTH-TOKEN: ${WAREHOUSE_DATA_HOARDER_TOKEN}" https://${WAREHOUSE_DATA_HOARDER_HOST}:7410/blobs/ |
  sed 's/,/\n/g' |
  grep ${HOSTNAME} |
  sort |
  head -n-${BACKUP_COUNT:-1} |
  sed 's/.*: \?"\(.*\)".*/\1/' |
  while read file
  do
    curl -k -H "X-AUTH-TOKEN: ${WAREHOUSE_DATA_HOARDER_TOKEN}" https://${WAREHOUSE_DATA_HOARDER_HOST}:7410/blobs/${file} -X DELETE
    aws s3 rm s3://${AWS_S3_BACKUP_BUCKET}/${APP_NAME}-${file}
  done
