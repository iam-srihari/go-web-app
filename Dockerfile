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
FROM debian:bullseye

WORKDIR /app

COPY --from=base /app/murali .
COPY --from=base /app/static ./static

EXPOSE 8080
CMD ["./murali"]

