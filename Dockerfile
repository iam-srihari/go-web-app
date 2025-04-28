# Use a Golang image with a shell for debugging purposes
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
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o murali .

#######################################################
# Temporary stage to debug with a shell (instead of distroless)
FROM golang:1.24

# Copy the binary from the previous stage
COPY --from=base /app/murali .

# Copy the static files from the previous stage
COPY --from=base /app/static ./static

# Expose the port on which the application will run
EXPOSE 8080

# Command to run the application
CMD ["/bin/bash"]
