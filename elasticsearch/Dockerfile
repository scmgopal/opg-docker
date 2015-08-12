FROM registry.service.dsd.io/opguk/jre-8:latest

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r elasticsearch && useradd -r -d /home/elasticsearch -m -g elasticsearch elasticsearch

RUN apt-get update && apt-get install -y curl ca-certificates --no-install-recommends && rm -rf /var/lib/apt/lists/*

# grab gosu for easy step-down from root
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
  && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

# Define software versions
ENV ELASTICSEARCH_VERSION 1.6.0
ENV ELASTICSEARCH_CURATOR_VERSION 3.2.0
ENV ELASTICSEARCH_CLOUD_AWS 2.6.0
ENV MARVEL_VERSION latest
ENV LICENSE_VERSION latest
ENV WATCHER_VERSION latest

# Define this confd variable here so we can use it early
ENV ELASTICSEARCH_PATH_REPO /usr/share/elasticsearch/repo

RUN echo "deb http://packages.elasticsearch.org/elasticsearch/${ELASTICSEARCH_VERSION%.*}/debian stable main" > /etc/apt/sources.list.d/elasticsearch.list

RUN apt-get update \
  && apt-get install elasticsearch=$ELASTICSEARCH_VERSION \
  && pip install elasticsearch-curator==$ELASTICSEARCH_CURATOR_VERSION \
  && rm -rf /var/lib/apt/lists/*

RUN /usr/share/elasticsearch/bin/plugin install elasticsearch/elasticsearch-cloud-aws/$ELASTICSEARCH_CLOUD_AWS
RUN /usr/share/elasticsearch/bin/plugin install elasticsearch/marvel/$MARVEL_VERSION
RUN /usr/share/elasticsearch/bin/plugin install elasticsearch/license/$LICENSE_VERSION
RUN /usr/share/elasticsearch/bin/plugin install elasticsearch/watcher/$WATCHER_VERSION

RUN mkdir -p /usr/share/elasticsearch/config

# Make and set owner/group on path repo here as if not directory ends up as root:root regardless of later chown/chgrp
RUN mkdir -p $ELASTICSEARCH_PATH_REPO
RUN chown elasticsearch $ELASTICSEARCH_PATH_REPO
RUN chgrp elasticsearch $ELASTICSEARCH_PATH_REPO

EXPOSE 9200 9300

# Provide default values for confd
ENV HOME /usr/share/elasticsearch
ENV PATH $HOME/bin:$PATH
ENV ELASTICSEARCH_NUMBER_OF_REPLICAS 0
ENV ELASTICSEARCH_NETWORK_BIND_HOST 0.0.0.0
ENV ELASTICSEARCH_SCRIPT_DISABLE_DYNAMIC true
ENV ELASTICSEARCH_PATH_DATA /usr/share/elasticsearch/data
ENV ELASTICSEARCH_DISCOVERY_ZEN_PING_MULTICASE_ENABLED false
ENV ELASTICSEARCH_DISCOVERY_ZEN_MINIMUM_MASTER_NODES 1
ENV ELASTICSEARCH_CLUSTER_NAME opgcore
#ENV ELASTICSEARCH_CLUSTER_NODES_ONE elasticsearch-01
ENV ELASTICSEARCH_NODE_NAME elasticsearch-01
ENV ELASTICSEARCH_INDICES_FIELDDATA_CACHE_SIZE 40%
ENV ELASTICSEARCH_GATEWAY_EXPECTED_NODES 1
ENV ELASTICSEARCH_GATEWAY_RECOVER_AFTER_TIME 5m
ENV ELASTICSEARCH_GATEWAY_RECOVER_AFTER_NODES 1
ENV ELASTICSEARCH_CLOUD_AWS_REGION eu-west-1
ENV ELASTICSEARCH_CLOUD_AWS_S3_PROTOCOL https
ENV ELASTICSEARCH_CLOUD_AWS_ACCESSKEY=
ENV ELASTICSEARCH_CLOUD_AWS_SECRETKEY=

VOLUME $ELASTICSEARCH_PATH_DATA
VOLUME $ELASTICSEARCH_PATH_REPO

# Extra chown/chgrp needed here otherwise volume remains root:root
RUN chown elasticsearch $ELASTICSEARCH_PATH_REPO
RUN chgrp elasticsearch $ELASTICSEARCH_PATH_REPO

ADD docker/confd /etc/confd

ADD docker/service/elasticsearch /etc/service/elasticsearch
RUN chmod a+x /etc/service/elasticsearch/run