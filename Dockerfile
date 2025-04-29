# Containerize the go application that we have created
# This is the Dockerfile that we will use to build the image
# and run the container

# Start with a base image
FROM golang:1.24 as base

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory
COPY go.mod ./

# Download all the dependencies
RUN go mod download

# Copy the source code to the working directory
COPY . .

# Build the application
RUN go build -o murali .

#######################################################
# Reduce the image size using multi-stage builds
# We will use a distroless image to run the application
FROM debian:bullseye-slim

# Set workdir
WORKDIR /app

# Install necessary certificates (optional but good practice)
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Copy the binary and static folder
COPY --from=base /app/murali .
COPY --from=base /app/static ./static

EXPOSE 8080

# Run the application
CMD ["./murali"]
