### Stage 1 - Java Build
#FROM maven:3.6.3-openjdk-11
FROM maven:3.6.3-openjdk-8 as builder

VOLUME /volume/gitrepo

RUN mkdir -p /local/gitrepo
WORKDIR /local/gitrepo
COPY . /local/gitrepo/
COPY pom.xml /local/gitrepo/pom.xml

RUN mvn clean package

### Stage 2 - Docker Build
FROM openjdk:8-jre-alpine as runner
COPY --from=builder /local/gitrepo/target/demo-all.jar /usr/app/demo-all.jar
COPY --from=builder /local/gitrepo/kafka.properties /usr/app/config/kafka.properties
WORKDIR /usr/app
EXPOSE 8080
CMD ["java","-Dproperties_path=/usr/app/config/kafka.properties","-jar","demo-all.jar"]
