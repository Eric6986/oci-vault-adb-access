FROM adoptopenjdk/openjdk11:jdk-11.0.2.9-slim
RUN addgroup --system spring && adduser --system spring -ingroup spring
USER spring:spring
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} device-api.jar
ENTRYPOINT ["java","-jar","device-api.jar"]
ENV PORT 8080
EXPOSE 8080
