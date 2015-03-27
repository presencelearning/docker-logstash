FROM fgaudin/base:3
MAINTAINER Francois Gaudin <francois@presencelearning.com>

RUN groupadd logstash -g 105043 && useradd logstash -u 105043 -d /opt/logstash -s /usr/sbin/nologin -g 105043

# Install Java.
RUN \
  apt-get update && apt-get -y install software-properties-common && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer && \
  wget -O logstash.tar.gz https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz && \
  mkdir -p /opt/logstash && tar xzf logstash.tar.gz -C /opt/logstash --strip-components=1 && \
  rm logstash.tar.gz

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN mkdir -p /mnt/logstash-forwarder

RUN mkdir -p /etc/logstash
COPY consul_template/conf.d /opt/consul_template/conf.d
COPY consul_template/templates /opt/consul_template/templates

COPY patterns/* /opt/logstash/patterns/
COPY entrypoint.sh /opt/logstash/entrypoint.sh
RUN chown -R logstash /opt/logstash && chmod +x /opt/logstash/entrypoint.sh
COPY supervisord.conf /etc/supervisor/conf.d/logstash.conf

USER logstash

RUN mkdir -p /opt/logstash/certificates

USER root

EXPOSE 5043 9500

VOLUME ["/opt/logstash/certificates"]

ENTRYPOINT ["/opt/logstash/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]