FROM dockerfile/java:oracle-java8
MAINTAINER Francois Gaudin <francois@presencelearning.com>

RUN groupadd logstash -g 105043 && useradd logstash -u 105043 -d /opt/logstash -s /usr/sbin/nologin -g 105043

RUN wget -O logstash.tar.gz https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz \
  && mkdir -p /opt/logstash && tar xzf logstash.tar.gz -C /opt/logstash --strip-components=1 \
  && rm logstash.tar.gz

RUN mkdir -p /mnt/logstash-forwarder

RUN mkdir -p /etc/logstash
COPY logstash.conf /etc/logstash/logstash.conf

COPY patterns/* /opt/logstash/patterns/
COPY entrypoint.sh /opt/logstash/entrypoint.sh
RUN chown -R logstash /opt/logstash && chmod +x /opt/logstash/entrypoint.sh

USER logstash

RUN mkdir -p /opt/logstash/certificates

EXPOSE 5043

VOLUME ["/opt/logstash/certificates"]

CMD ["/opt/logstash/bin/logstash -f /etc/logstash/logstash.conf"]
ENTRYPOINT ["/opt/logstash/entrypoint.sh"]
