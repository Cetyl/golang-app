# Stage 1: Build the application
FROM ubuntu AS build

RUN apt-get update && apt-get install -y golang-go

ENV GO111MODULE=off

COPY . .

RUN CGO_ENABLED=0 go build -o /app .

# Stage 2: Create the final image
FROM gcr.io/distroless/base

# Copy the compiled binary from the build stage
COPY --from=build /app /app

# If you have static files to copy, adjust the path accordingly
COPY --from=build ./static ./static

# Expose the port on which the application will run
EXPOSE 8080

# Set the entrypoint for the container to run the binary
ENTRYPOINT ["/app"]

