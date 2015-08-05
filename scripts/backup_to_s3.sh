: ${S3_BUCKET:?"No value supplied for s3 bucket name"}

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
pg_dump -j 12 -Fd -f $@ /backup_dump $PGDATABASE
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

bucket_count=`aws s3 ls s3://$S3_BUCKET | wc -l`
if [[ bucket_count -gt 0 ]]; then
  echo "${S3_BUCKET} bucket exists"
else
  echo "${S3_BUCKET} bucket does not exist"
  echo "Create s3://${S3_BUCKET}"
  aws s3 mb s3://$S3_BUCKET
fi

aws s3 cp $zipped_filename s3://$S3_BUCKET/
rm $zipped_filename
