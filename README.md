# postgres-s3-backup
Docker image with PostgreSQL and AWS CLI installed for backing up a pg database to S3.

## Usage

### Start image
```docker run --name some-image-name -e PGHOST="" -e PGPORT="" -e PGDATABASE="" -e PGUSER="" -e PGPASSWORD="" -e AWS_ACCESS_KEY_ID="" -e AWS_SECRET_ACCESS_KEY="" -e S3_BUCKET="" postgres-s3-backup```

Both aws and psql must be configured in order to run those functions on this image. You can do that by either setting the environment variables in the docker run command, or by setting them through the awscli or psql commands. More information can be found at [PSQL's Documentation](http://www.postgresql.org/docs/9.2/static/app-psql.html) and [AWS' documentation](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html).
 
## Supported Docker Versions
This image is officially supported on Docker version 1.7.1.
