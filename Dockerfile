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
    python-virtualenv

# Install AWS CLI
RUN mkdir aws && \
    virtualenv aws/env && \
    ./aws/env/bin/pip install awscli && \
    echo 'source $HOME/aws/env/bin/activate' >> .bashrc && \
    echo 'complete -C aws_completer aws' >> .bashrc
