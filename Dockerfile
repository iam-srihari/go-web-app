# First stage: Build the Go application
FROM golang:1.24 as builder

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory
COPY go.mod go.sum ./

# Download all the dependencies
RUN go mod download

# Copy the source code to the working directory
COPY . .

# Set CGO_ENABLED=0 for static build and build the application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o murali . && ls -al /app


#######################################################

# Second stage: Copy the binary into a smaller image
FROM gcr.io/distroless/base

# Copy the binary from the builder stage
COPY --from=builder /app/murali /murali

# Copy the static files
COPY --from=builder /app/static /static

# Expose the port
EXPOSE 8080

# Command to run the binary
CMD ["/murali"]
