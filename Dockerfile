FROM ubuntu

# Install basic utility
RUN apt-get update && \
    apt-get install -y \
    ssh

# Install Postgres
 RUN apt-get install -y postgresql-client

# Install Python for AWS CLI
RUN apt-get install -y \
    python \
    python-pip \
    python-virtualenv \
    groff

# Install AWS CLI
RUN pip install awscli
