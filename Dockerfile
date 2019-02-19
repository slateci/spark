FROM openjdk:8-alpine

RUN set -ex && \
    apk upgrade --no-cache && \
    apk add --no-cache bash tini libc6-compat linux-pam && \
    mkdir -p /opt/spark && \
    mkdir -p /opt/spark/work-dir && \
    touch /opt/spark/RELEASE && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd

COPY jars /opt/spark/jars
COPY bin /opt/spark/bin
COPY sbin /opt/spark/sbin
# COPY entrypoint.sh /opt/
# COPY examples /opt/spark/examples
# COPY kubernetes/tests /opt/spark/tests
# COPY data /opt/spark/data

ENV SPARK_HOME /opt/spark

WORKDIR /opt/spark/work-dir

# ENTRYPOINT [ "/opt/entrypoint.sh" ]