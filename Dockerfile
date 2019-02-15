FROM openjdk:8-alpine3.8
## Spark standalone mode Dockerfile


ENV SPARK_HOME=/spark \
    SPARK_PGP_KEYS="6EC5F1052DF08FF4 EDA00CE834F0FC5C 6BAC72894F4FDC8A"

RUN adduser -Ds /bin/bash -h ${SPARK_HOME} spark

RUN  apk add --no-cache bash tini libc6-compat linux-pam krb5 krb5-libs && \
    # download dist
    apk add --virtual .deps --no-cache curl tar gnupg

RUN cd /tmp && export GNUPGHOME=/tmp

RUN curl -s -O https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz 
RUN curl -s -O https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz.asc  

RUN gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys ${SPARK_PGP_KEYS} && \
    gpg --batch --verify spark-2.4.0-bin-hadoop2.7.tgz.asc spark-2.4.0-bin-hadoop2.7.tgz

# create spark directories
RUN mkdir -p ${SPARK_HOME}/work ${SPARK_HOME}/conf && chown spark:spark ${SPARK_HOME}/work && \
    tar -xzf spark-2.4.0-bin-hadoop2.7.tgz --no-same-owner --strip-components 1 && \
    mv bin data examples jars sbin ${SPARK_HOME} && \
    # cleanup
    apk --no-cache del .deps && ls -A | xargs rm -rf

COPY entrypoint.sh /
# COPY spark-env.sh ${SPARK_HOME}/conf/

WORKDIR ${SPARK_HOME}/work
ENTRYPOINT [ "/entrypoint.sh" ]

# Specify the User that the actual main process will run as
USER spark:spark