# Use OpenJDK 11 as base image
FROM openjdk:11-jdk

# Set working directory
WORKDIR /app

# Install Maven and X11 libraries for Swing GUI
RUN apt-get update && apt-get install -y maven \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libxrandr2 \
    libxss1 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxfixes3 \
    libxinerama1 \
    libxrandr2 \
    libxtst6 \
    libnss3 \
    libcups2 \
    libdrm2 \
    libgtk-3-0 \
    libasound2

# Copy Maven pom.xml first for better caching
COPY pom.xml .

# Download dependencies (this layer will be cached if pom.xml doesn't change)
RUN mvn dependency:go-offline -B

# Copy source code
COPY src/ ./src/

# Build the application
RUN mvn clean compile -DskipTests

# Create a script to run the Swing application
RUN echo '#!/bin/bash\njava -cp "target/classes:$(mvn dependency:build-classpath -Dmdep.outputFile=/dev/stdout -q)" com.houarizegai.calculator.App' > run.sh && \
    chmod +x run.sh

# Set the entrypoint
ENTRYPOINT ["./run.sh"]
