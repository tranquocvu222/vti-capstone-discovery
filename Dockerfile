FROM openjdk:8-jdk-alpine
RUN adduser -D -u 1001 appuser

WORKDIR /app
COPY build/libs/vti-capstone-discovery-0.0.1-SNAPSHOT.jar vti-capstone-discovery.jar
RUN chown appuser:appuser vti-capstone-discovery.jar

USER appuser

EXPOSE 8761

CMD ["java", "-jar", "vti-capstone-discovery.jar"]