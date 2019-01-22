# Nanobox backup scripts

Each backup script can be used in your boxfile.yaml. A few environment
variables needs to be set in your nanobox environment or before you execute the
script.

All backups should be uploaded to a S3 server. This is common for most backup
scripts you will find in this directory.

Make sure that your nanobox environment has the following environment variables
set before you continue.

- AWS_S3_ENDPOINT_URL
- AWS_S3_BACKUP_BUCKET
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY

To add an environment variable to the nanobox environment

```bash
nanobox evar add [name of your nanobox app] MY_EVAR=myvalue
```

Each component that is using the backup scripts will also need awscli. You can install that by adding `py36-awscli` as an extra package like this.

```yaml
data.name:
  image: imagename
  extra_packages:
    - py36-awscli
```

## Postgres 9

The script expects that your postgresql component is named `data.db`. It should
like similar to this without backups configurated.

```yaml
data.db:
  image: nanobox/postgresql:9.6
```

**You must** make sure that the environment variable `DATABASE_NAME` is correct. It will default to backup the database named `gonano` unless you override that by setting the `DATABASE_NAME` variable before you execute the script using bash. You could also set the variable directly to the nanobox environment like this.

```bash
nanobox evar add [name of your nanobox app] DATABASE_NAME=foobar
```

To backup once you could run

```bash
curl -fsSL https://raw.githubusercontent.com/standout/Coding/master/nanobox/backup-scripts/postgres9.sh | DATABASE_NAME=foobar bash
```

To backup each night at 03:00 you should change your comoponent in the boxfile to look like this

```yaml
data.db:
  image: nanobox/postgresql:9.6
  extra_packages:
    - py36-awscli
  cron:
    - id: backup
      schedule: '0 3 * * *'
      command: curl -fsSL https://raw.githubusercontent.com/standout/Coding/master/nanobox/backup-scripts/postgres9.sh | DATABASE_NAME=foobar bash
```

### Restore from backup

First you need to enter the console for the database.

```bash
nanobox console [remote] data.db
```

Restore from latest backup that is stored in the warehouse.

```bash
curl -k -H "X-AUTH-TOKEN: ${WAREHOUSE_DATA_HOARDER_TOKEN}" https://${WAREHOUSE_DATA_HOARDER_HOST}:7410/blobs/backup-${HOSTNAME}-{date}.sql.gz | gunzip | PGPASSWORD=${DATA_DB_PASS} pg_restore -U ${DATA_DB_USER} -d ${DATABASE_NAME} -w -Fc -O
```

Or restore from any file available in a public url

```bash
curl -k [url to gziped backup file] | gunzip | PGPASSWORD=${DATA_DB_PASS} pg_restore -U ${DATA_DB_USER} -d ${DATABASE_NAME} -w -Fc -O
```

## MySQL 5

The script expects that your mysql component is named `data.db`. It should
look similar to this without backups configurated.

```yaml
data.db:
  image: nanobox/mysql:5.6
```

**You must** make sure that the environment variable `DATABASE_NAME` is correct before you execute the script using bash. You could also set the variable directly to the nanobox environment like this.

```bash
nanobox evar add [name of your nanobox app] DATABASE_NAME=foobar
```

To backup once you could run

```bash
curl -fsSL https://raw.githubusercontent.com/standout/Coding/master/nanobox/backup-scripts/mysql5.sh | DATABASE_NAME=foobar bash
```

To backup each night at 03:00 you should change your component in the boxfile to look like this

```yaml
data.db:
  image: nanobox/nanobox/mysql:5.6
  extra_packages:
    - py36-awscli
  cron:
    - id: backup
      schedule: '0 3 * * *'
      command: curl -fsSL https://raw.githubusercontent.com/standout/Coding/master/nanobox/backup-scripts/mysql5.sh | DATABASE_NAME=foobar bash
```

### Restore from backup

First you need to enter the console for the database.

```bash
nanobox console [remote] data.db
```

Restore from latest backup that is stored in the warehouse.

```bash
curl -k -H "X-AUTH-TOKEN: ${WAREHOUSE_DATA_HOARDER_TOKEN}" https://${WAREHOUSE_DATA_HOARDER_HOST}:7410/blobs/backup-${HOSTNAME}-{date}.sql.gz | gunzip | mysql -u ${DATA_DB_USER} -p"${DATA_DB_PASS}" ${DATABASE_NAME}
```

Or restore from any file available in a public url

```bash
curl -k [url to gziped backup file] | gunzip | mysql -u ${DATA_DB_USER} -p"${DATA_DB_PASS}" ${DATABASE_NAME}
```

## UNFS storage

To backup once you could run

```bash
curl -fsSL https://raw.githubusercontent.com/standout/Coding/master/nanobox/backup-scripts/unfs.sh | bash
```

To backup each night at 03:00 you should change your comoponent in the boxfile to look like this

```yaml
data.storage:
  image: nanobox/unfs:0.9
  extra_packages:
    - py36-awscli
  cron:
    - id: backup
      schedule: '0 3 * * *'
      command: curl -fsSL https://raw.githubusercontent.com/standout/Coding/master/nanobox/backup-scripts/unfs.sh | bash
```

### Restore from backup

First you need to enter the console for the database.

```bash
nanobox console [remote] data.storage
```

Restore from latest backup that is stored in the warehouse.

```bash
curl -k -H "X-AUTH-TOKEN: ${WAREHOUSE_DATA_HOARDER_TOKEN}" https://${WAREHOUSE_DATA_HOARDER_HOST}:7410/blobs/backup-${HOSTNAME}-{date}.tgz | tar xz -C /data/var/db/unfs/
```

Or restore from any file available in a public url

```bash
curl -k [url to .tgz file] | tar xz -C /data/var/db/unfs/
```


## Redis

To backup once you could run

```bash
curl -fsSL https://raw.githubusercontent.com/standout/Coding/master/nanobox/backup-scripts/redis.sh | bash
```

To backup each night at 03:00 you should change your comoponent in the boxfile to look like this

```yaml
data.redis:
  image: nanobox/redis
  extra_packages:
    - py36-awscli
  cron:
    - id: backup
      schedule: '0 3 * * *'
      command: curl -fsSL https://raw.githubusercontent.com/standout/Coding/master/nanobox/backup-scripts/redis.sh | bash
```

### Restore from backup

First you need to enter the console for the database.

```bash
nanobox console [remote] data.redis
```

Restore from latest backup that is stored in the warehouse.

```bash
sudo sv stop cache
curl -k -H "X-AUTH-TOKEN: ${WAREHOUSE_DATA_HOARDER_TOKEN}" https://${WAREHOUSE_DATA_HOARDER_HOST}:7410/blobs/backup-${HOSTNAME}-{date}.rdb -o /data/var/db/redis/dump.rdb
sudo sv start cache
```

Or restore from any file available in a public url

```bash
sudo sv stop cache
curl -k [url to .rdb file] -o /data/var/db/redis/dump.rdb
sudo sv start cache
```
