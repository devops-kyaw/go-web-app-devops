FROM golang:1.22.5 AS build

# Set destination for COPY
WORKDIR /app

# Download Go modules
COPY go.mod ./

RUN go mod download

COPY * ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /go-web-app

FROM gcr.io/distroless/static-debian12	

COPY --from=build /go-web-app /go-web-app

EXPOSE 8080

CMD ["/go-web-app"]              