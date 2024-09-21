# Use a Maven image to build the application
FROM maven:3.8.1-openjdk-17 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and install dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code and build the app
COPY src ./src
RUN mvn package -DskipTests

# Use an official OpenJDK image for the runtime
FROM openjdk:17-jdk-slim

# Set the working directory in the runtime image
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/hemanthforyou-channel-app-1.0-SNAPSHOT.jar app.jar

# Expose the port
EXPOSE 8080

# Run the Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]
