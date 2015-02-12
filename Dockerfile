FROM dockerfile/java:oracle-java8
MAINTAINER Francois Gaudin <francois@presencelearning.com>

RUN wget -O logstash.tar.gz https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz \
  && mkdir -p /opt/logstash && tar xzf logstash.tar.gz -C /opt/logstash --strip-components=1 \
  && rm logstash.tar.gz

COPY patterns/* /opt/logstash/patterns/

RUN mkdir -p /mnt/logstash-forwarder

RUN mkdir -p /etc/logstash
COPY logstash.conf /etc/logstash/logstash.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 5043

VOLUME ["/mnt/logstash-forwarder"]

CMD ["/opt/logstash/bin/logstash -f /etc/logstash/logstash.conf"]
ENTRYPOINT ["/entrypoint.sh"]
