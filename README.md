# postgres-s3-backup
Docker image with PostgreSQL and AWS CLI installed for backing up a pg database to S3.

## Usage

### Start image
```docker run --name some-image-name -e [PG AND AWS ENV variables]```

Both aws and psql must be configured in order to run those functions on this image. You can do that by either setting the environment variables in the docker run command, or by setting them through the awscli or psql commands. More information can be found at [PSQL's Documentation](http://www.postgresql.org/docs/9.2/static/app-psql.html) and [AWS' documentation](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html).

### Run the Backup Script

To run the backup script, you can either connect to the docker image, or run directly from the docker run command. The backup script is the following:

```/script/backup_to_s3.sh [NAME_OF_S3_BUCKET]```
 
## Supported Docker Versions
This image is officially supported on Docker version 1.7.1.
