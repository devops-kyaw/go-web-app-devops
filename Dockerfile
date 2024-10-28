FROM golang:1.22.5 AS build

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /go-web-app

FROM gcr.io/distroless/base-debian12

# Create the target directory
RUN mkdir /go-web-app

COPY --from=build /go-web-app /go-web-app

# Copy only necessary static files (adjust the path as needed)
COPY --from=build /app/static/dist /go-web-app/static 

EXPOSE 8080

USER nonroot:nonroot

CMD ["/go-web-app"] 
