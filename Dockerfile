FROM golang:1.13-alpine AS build

LABEL repository="https://github.com/jakejarvis/hugo-build-action"
LABEL homepage="https://jarv.is/"
LABEL maintainer="Jake Jarvis <jake@jarv.is>"

ARG CGO=0
ENV CGO_ENABLED=${CGO}
ENV GOOS=linux
ENV GO111MODULE=on

ARG HUGO_COMMIT

WORKDIR /go/src/github.com/gohugoio/hugo

RUN apk update && \
    apk add --no-cache git musl-dev && \
    git clone --depth 1 https://github.com/gohugoio/hugo.git $GOPATH/src/github.com/gohugoio/hugo && \
    if [ ! -z "$HUGO_COMMIT" ]; then git reset --hard $HUGO_COMMIT; fi && \
    go get -d . && \
    go install -ldflags '-s -w'

# ---

FROM alpine:latest

COPY --from=build /go/bin/hugo /usr/bin/hugo

ENTRYPOINT ["hugo"]
