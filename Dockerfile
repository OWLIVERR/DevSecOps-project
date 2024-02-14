# Use a Maven builder image to build the Java application
FROM maven:3.8.4-openjdk-11-slim AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven project definition files
COPY pom.xml .

# Copy the entire source code
COPY src src

# Build the application
RUN mvn clean package -DskipTests

# Use a lightweight OpenJDK 11 JRE image as the base image for the final Docker image
FROM adoptopenjdk/openjdk11:jre-11.0.12_7-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the builder stage to the final image
COPY --from=builder /app/target/*.jar app.jar

# Expose the port the application runs on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]
