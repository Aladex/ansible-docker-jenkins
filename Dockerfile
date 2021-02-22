FROM alpine:3.11

COPY requirements.txt /requirements.txt

RUN apk --no-cache add \
        sudo \
        python3\
        py3-pip \
        openssl \
        ca-certificates \
        sshpass \
        openssh-client \
        rsync \
        git && \
    apk --no-cache add --virtual build-dependencies \
        python3-dev \
        libffi-dev \
        openssl-dev \
        build-base && \
    pip3 install -r /requirements.txt && \
    apk del build-dependencies && \
    ansible-galaxy collection install community.libvirt && \
    ansible-galaxy collection install community.general && \
    rm -rf /var/cache/apk/*

RUN mkdir /ansible && \
    mkdir -p /.ansible && \
    chmod -R 777 /.ansible

RUN addgroup -g 1000 -S ansible && \
    adduser -u 1000 -S ansible -G ansible

WORKDIR /ansible