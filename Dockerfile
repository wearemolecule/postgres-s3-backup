FROM ubuntu:yakkety

# Install basic utility
RUN apt-get update && \
    apt-get install -y \
    ssh

# Install Postgres
RUN apt-get install -y postgresql-client-9.5

# Install Python for AWS CLI
RUN apt-get install -y \
    python \
    python-pip \
    python-virtualenv \
    groff

# Install AWS CLI
RUN pip install awscli

# Add the backup Script to Image
RUN mkdir /scripts
ADD /scripts/backup_to_s3.sh /scripts/backup_to_s3.sh
RUN chmod +x /scripts/backup_to_s3.sh

CMD /scripts/backup_to_s3.sh
