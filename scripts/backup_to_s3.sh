if [ -z "$1" ]
  then
    echo "No value supplied for s3 bucket name"
    exit -1
fi

echo "Checking Credentials before starting backup"
: ${PGHOST:?"Need to set PGHOST non-empty?"}
: ${PGPORT:?"Need to set PGPORT non-empty?"}
: ${PGDATABASE:?"Need to set PGDATABASE non-empty?"}
: ${PGUSER:?"Need to set PGUSER non-empty?"}
: ${PGPASSWORD:?"Need to set PGPASSWORD non-empty?"}

if [ ! -e ~/.aws/credentials ]
then
  echo "AWS credentials file not found." >&2
  : ${AWS_ACCESS_KEY_ID:?"Need to set AWS_ACCESS_KEY_ID non-empty?"}
  : ${AWS_SECRET_ACCESS_KEY:?"Need to set AWS_SECRET_ACCESS_KEY non-empty?"}
fi

echo "Starting pgdump"
pg_dump -j 12 -Fd -f /backup_dump $PGDATABASE
backup_folder=`ls /backup_dump | wc -l`
if [[ backup_folder -gt 0 ]]; then
  echo "PGDUMP Complete"
else
  echo "PGDUMP failed"
  exit -1
fi

now=`date +%d-%m-%Y-%H-%M-%S`
zipped_filename="$PGDATABASE-$now.tar.gz"
tar -zcvf $zipped_filename  /backup_dump/ && rm -rf /backup_dump/
echo "Completed Backup"

s3_bucket=$1
bucket_count=`aws s3 ls s3://$s3_bucket | wc -l`
if [[ bucket_count -gt 0 ]]; then
  echo "${s3_bucket} bucket exists"
else
  echo "${s3_bucket} bucket does not exist"
  echo "Create s3://${s3_bucket}"
  aws s3 mb s3://$s3_bucket
fi

aws s3 cp $zipped_filename s3://$s3_bucket/
