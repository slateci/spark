FROM openjdk:8-alpine3.8
## Spark standalone mode Dockerfile

ARG release

ENV SPARK_HOME=/spark \
    VERSION=2.4.0 \
    SPARK_PGP_KEYS="DB0B21A012973FD0 7C6C105FFC8ED089 FD8FFD4C3A0D5564"

RUN adduser -Ds /bin/bash -h ${SPARK_HOME} spark

RUN  apk add --no-cache bash tini libc6-compat linux-pam krb5 krb5-libs && \
    # download dist
    apk add --virtual .deps --no-cache curl tar gnupg

RUN cd /tmp && export GNUPGHOME=/tmp && \
    file=spark-${VERSION}-bin-without-hadoop.tgz && \
    echo ${file}

RUN curl --remote-name-all -w "%{url_effective} fetched\n" -sSL \
    https://archive.apache.org/dist/spark/spark-${VERSION}/{${file},${file}.asc}

RUN gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys ${SPARK_PGP_KEYS} && \
    gpg --batch --verify ${file}.asc ${file} && \
    # create spark directories
    mkdir -p ${SPARK_HOME}/work ${SPARK_HOME}/conf && chown spark:spark ${SPARK_HOME}/work && \
    tar -xzf ${file} --no-same-owner --strip-components 1 && \
    mv bin data examples jars sbin ${SPARK_HOME} && \
    # cleanup
    apk --no-cache del .deps && ls -A | xargs rm -rf

COPY entrypoint.sh /
# COPY spark-env.sh ${SPARK_HOME}/conf/

WORKDIR ${SPARK_HOME}/work
ENTRYPOINT [ "/entrypoint.sh" ]

# Specify the User that the actual main process will run as
USER spark:spark