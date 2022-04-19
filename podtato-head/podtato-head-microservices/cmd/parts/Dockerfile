FROM docker.io/library/golang:latest AS builder

ARG PART
ENV PART=${PART}

ENV GO111MODULE=on \
	CGO_ENABLED=0

WORKDIR /build

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN go build -o /serve-${PART} ./cmd/parts

EXPOSE 9000

FROM scratch

ARG VERSION="1.0"
ENV PODTATO_VERSION=${VERSION}

ARG PART
ENV PART=${PART}

COPY --from=builder /serve-${PART} /serve
ENTRYPOINT ["/serve"]
