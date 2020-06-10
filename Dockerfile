FROM golang:1.14.4-buster as builder

RUN go get -u -ldflags '-w -s' google.golang.org/protobuf/cmd/protoc-gen-go && \
    mkdir -p /protobuf/google/protobuf && \
    for f in any duration descriptor empty struct timestamp wrappers; do \
        curl -L -o /protobuf/google/protobuf/${f}.proto https://raw.githubusercontent.com/google/protobuf/master/src/google/protobuf/${f}.proto; \
    done


FROM alpine:3.12

RUN apk add --no-cache protobuf git openssh-client gettext

COPY --from=builder /go/bin/protoc-gen-go /usr/local/bin/
COPY --from=builder /protobuf /protobuf
