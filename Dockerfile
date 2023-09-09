FROM maven:3.8.3-amazoncorretto-17

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn -B package --file pom.xml

EXPOSE 8080:8080

ENTRYPOINT ["java", "-jar", "target/app.jar"]