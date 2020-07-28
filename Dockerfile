### Stage 1 - Java Build
FROM maven:3.6.3-openjdk-11

VOLUME /volume/gitrepo

RUN mkdir -p /local/gitrepo
WORKDIR /local/gitrepo
COPY . /local/gitrepo/
COPY pom.xml /local/gitrepo/pom.xml

RUN mvn clean package

### Stage 2 - Docker Build
FROM openjdk:11-slim
COPY --from=0 /local/gitrepo/target/demo-all.jar /usr/app/demo-all.jar
COPY --from=0 /local/gitrepo/kafka.properties /usr/app/kafka.properties
WORKDIR /usr/app
CMD ["java","-Dproperties_path=/usr/app/kafka.properties","-jar","demo-all.jar"]
