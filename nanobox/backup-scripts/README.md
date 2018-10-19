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

```
$ nanobox evar add NAME_OF_YOUR_NANOBOX_APP MY_EVAR=myvalue
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

```
$ nanobox evar add NAME_OF_YOUR_NANOBOX_APP DATABASE_NAME=foobar
```

To backup once you could run

```
$ curl -fsSL https://raw.githubusercontent.com/standout/Coding/master/nanobox/backup-scripts/postgres9.sh | DATABASE_NAME=foobar bash
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

## MySQL 5

The script expects that your mysql component is named `data.db`. It should
like similar to this without backups configurated.

```yaml
data.db:
  image: nanobox/mysql:5.6
```

**You must** make sure that the environment variable `DATABASE_NAME` is correct. It will default to backup the database named `gonano` unless you override that by setting the `DATABASE_NAME` variable before you execute the script using bash. You could also set the variable directly to the nanobox environment like this.

```
$ nanobox evar add NAME_OF_YOUR_NANOBOX_APP DATABASE_NAME=foobar
```

To backup once you could run

```
$ curl -fsSL https://raw.githubusercontent.com/standout/Coding/master/nanobox/backup-scripts/mysql5.sh | DATABASE_NAME=foobar bash
```

To backup each night at 03:00 you should change your comoponent in the boxfile to look like this

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

## UNFS storage

To backup once you could run

```
$ curl -fsSL https://raw.githubusercontent.com/standout/Coding/master/nanobox/backup-scripts/unfs.sh | bash
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
