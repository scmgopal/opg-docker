FROM registry.service.dsd.io/opguk/base:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux

RUN apt-get update && \
    apt-get install -y git-core && \
    apt-get install -y libfreetype6 && \
    apt-get install -y libfontconfig && \
    apt-get install -y python && \
    apt-get install -y php5-cli && \
    apt-get install -y php5-imap && \
    php5enmod imap

# The bitbucket location gives occasional "403 Forbidden" errors, breaking the build, so we're using our own source instead
# ADD https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2 /tmp/phantomjs.tar.bz2
ADD https://raw.githubusercontent.com/ministryofjustice/opg-phantomjs/master/phantomjs-1.9.8-linux-x86_64.tar.bz2 /tmp/phantomjs.tar.bz2

RUN tar xjfv /tmp/phantomjs.tar.bz2 -C /usr/local/  && \
    ln -sf /usr/local/phantomjs*/bin/phantomjs /usr/local/bin/phantomjs && \
    rm -f /tmp/phantomjs.tar.bz2

RUN git clone https://github.com/n1k0/casperjs.git /usr/local/casperjs && \
    git -C /usr/local/casperjs checkout tags/1.1-beta3 && \
    ln -sf /usr/local/casperjs/bin/casperjs /usr/local/bin/casperjs
