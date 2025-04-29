FROM golang:1.24 as builder

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code to the working directory
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o murali .

#######################################################

# Use a shell-friendly image for debugging (e.g., Alpine)
FROM alpine:latest

# Install bash or sh
RUN apk add --no-cache bash

# Copy the binary from the builder stage
COPY --from=builder /app/murali /murali
COPY --from=builder /app/static /static

# Expose the port
EXPOSE 8080

# Command to run the binary
CMD ["/murali"]
