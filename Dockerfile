# Multi-stage Dockerfile for Flutter Web Application

# Stage 1: Build the Flutter web application
FROM ubuntu:22.04 AS build

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter SDK
ENV FLUTTER_VERSION=3.24.5
ENV FLUTTER_HOME=/opt/flutter
RUN git clone https://github.com/flutter/flutter.git -b stable ${FLUTTER_HOME}
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

# Pre-download Flutter dependencies
RUN flutter doctor
RUN flutter config --enable-web

# Set working directory
WORKDIR /app

# Copy pubspec files and download dependencies
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy the rest of the application
COPY . .

# Build the Flutter web application
RUN flutter build web --release

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy nginx configuration
COPY docker/nginx.conf /etc/nginx/nginx.conf

# Copy the built web app from build stage
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
