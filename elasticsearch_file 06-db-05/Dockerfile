FROM centos:7

ENV PATH=/usr/lib:/elasticsearch-8.6.2/jdk/bin:/elasticsearch-8.6.2/bin:$PATH

RUN yum install -y perl-Digest-SHA

RUN curl -o elasticsearch-8.6.2-linux-x86_64.tar.gz https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.6.2-linux-x86_64.>
    curl -o elasticsearch-8.6.2-linux-x86_64.tar.gz.sha512 https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.6.2-linux->
    shasum -a 512 -c elasticsearch-8.6.2-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-8.6.2-linux-x86_64.tar.gz && \
    rm elasticsearch-8.6.2-linux-x86_64.tar.gz && \
    rm elasticsearch-8.6.2-linux-x86_64.tar.gz.sha512

ENV ES_HOME=/elasticsearch-8.6.2

RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000

RUN mkdir /var/lib/elasticsearch

WORKDIR /var/lib/elasticsearch

RUN set -ex && for path in data logs config config/scripts; do \
        mkdir -p "$path"; \
        chown -R elasticsearch:elasticsearch "$path"; \
    done

RUN mkdir /elasticsearch-8.6.2/snapshots && \
    chown -R elasticsearch:elasticsearch /elasticsearch-8.6.2

COPY logging.yml /elasticsearch-8.6.2/config/
COPY elasticsearch.yml /elasticsearch-8.6.2/config/

USER elasticsearch

CMD ["elasticsearch"]

EXPOSE 9200 9300
