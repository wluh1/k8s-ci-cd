FROM docker.io/library/golang:latest AS builder

ENV GO111MODULE=on \
	CGO_ENABLED=0

WORKDIR /build

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN go build -o entry ./cmd/entry

FROM scratch

ARG VERSION="1.0"
ENV PODTATO_VERSION=${VERSION}

COPY --from=builder /build/entry /entry

EXPOSE 9000

ENTRYPOINT ["/entry"]
