FROM arm64v8/elasticsearch:7.8.0

RUN yum install -y wget git unzip java-1.8.0-openjdk-devel

RUN mkdir /opt/gradle \
    && wget https://services.gradle.org/distributions/gradle-5.0-bin.zip -P /opt/ \
    && unzip -d /opt/gradle /opt/gradle-5.0-bin.zip

ENV GRADLE_HOME="/opt/gradle/gradle-5.0}"
ENV PATH="/opt/gradle/gradle-5.0/bin:${PATH}"
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.312.b07-1.el7_9.aarch64

WORKDIR /opt

RUN wget https://github.com/sing1ee/elasticsearch-jieba-plugin/archive/refs/tags/v7.7.1.zip \
    && unzip ./v7.7.1.zip \
    && cd elasticsearch-jieba-plugin-7.7.1 \
    && sed -i 's/7\.7\.0/7\.8\.0/g' build.gradle \
    && sed -i 's/7\.7\.0/7\.8\.0/g' ./src/main/resources/plugin-descriptor.properties \
    && git clone https://github.com/sing1ee/jieba-analysis.git \
    && cd /opt/elasticsearch-jieba-plugin-7.7.1 \
    && gradle pz \
    && mv build/distributions/elasticsearch-jieba-plugin-7.8.0.zip /usr/share/elasticsearch/plugins \
    && cd /usr/share/elasticsearch/plugins \
    && unzip elasticsearch-jieba-plugin-7.8.0.zip \
    && rm elasticsearch-jieba-plugin-7.8.0.zip \
    && rm -rf /opt/{elasticsearch-jieba-plugin-*,*.zip} \
    && mkdir -p /usr/share/elasticsearch/config/stopwords \
    && touch /usr/share/elasticsearch/config/stopwords/stopwords.txt \
    && mkdir -p /usr/share/elasticsearch/config/synonyms \
    && touch /usr/share/elasticsearch/config/synonyms/synonyms.txt \
    && chown -R elasticsearch /usr/share/elasticsearch/ 

USER elasticsearch
WORKDIR /usr/share/elasticsearch