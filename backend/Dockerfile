# syntax=docker/dockerfile:1
ARG JAVA_VERSION=17

# ---- Build (Maven) ----
FROM maven:3.9-eclipse-temurin-${JAVA_VERSION} AS build
ARG JAVA_VERSION
WORKDIR /app
COPY pom.xml .
RUN mvn -B -q dependency:go-offline
COPY src ./src
RUN mvn -B -q -DskipTests -Djava.version=${JAVA_VERSION} package

# ---- Runtime (JRE) ----
FROM eclipse-temurin:${JAVA_VERSION}-jre
RUN useradd --system --uid 1001 --no-create-home app
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
USER 1001
ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=75"
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
