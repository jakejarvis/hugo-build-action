FROM golang:1.13-alpine AS build

LABEL repository="https://github.com/jakejarvis/hugo-build-action"
LABEL homepage="https://jarv.is/"
LABEL maintainer="Jake Jarvis <jake@jarv.is>"

ARG HUGO_COMMIT

ARG CGO=0
ENV CGO_ENABLED=${CGO}
ENV GOOS=linux
ENV GO111MODULE=on

WORKDIR /go/src/github.com/gohugoio/hugo

RUN apk update && \
    apk add --no-cache git musl-dev && \
    git clone https://github.com/gohugoio/hugo.git $GOPATH/src/github.com/gohugoio/hugo && \
    if [ ! -z "$HUGO_COMMIT" ]; then git reset --hard $HUGO_COMMIT; fi && \
    go get -d . && \
    go install -ldflags '-s -w'

RUN hugo version

# ---

FROM alpine:latest

# Twitter oEmbed shortcode fails without this (x509: certificate signed by unknown authority)
# https://github.com/google/go-github/issues/1049
RUN apk update && \
    apk add --no-cache ca-certificates && \
    update-ca-certificates

COPY --from=build /go/bin/hugo /usr/bin/hugo

ENTRYPOINT ["hugo"]
