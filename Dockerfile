FROM golang:1.13-alpine3.11 AS build

LABEL repository="https://github.com/jakejarvis/hugo-build-action"
LABEL homepage="https://jarv.is/"
LABEL maintainer="Jake Jarvis <jake@jarv.is>"

ARG HUGO_COMMIT
ARG HUGO_BUILD_TAGS=extended

ARG CGO=1
ENV CGO_ENABLED=${CGO}
ENV GOOS=linux
ENV GO111MODULE=on

WORKDIR /go/src/github.com/gohugoio/hugo

# clone Hugo from master branch and install
RUN apk update && \
    apk add --no-cache git gcc g++ musl-dev && \
    git clone https://github.com/gohugoio/hugo.git $GOPATH/src/github.com/gohugoio/hugo && \
    if [ ! -z "${HUGO_COMMIT}" ]; then git reset --hard ${HUGO_COMMIT}; fi && \
    go get -d . && \
    go install -ldflags '-s -w' --tags "${HUGO_BUILD_TAGS}"

# make sure everything's okay
RUN hugo version

# ---

FROM alpine:3.11

# copy built binary from last step
COPY --from=build /go/bin/hugo /usr/bin/hugo

# libc6-compat & libstdc++ are required for extended SASS libraries
# ca-certificates are required to fetch outside resources (like Twitter oEmbeds)
RUN apk update && \
    apk add --no-cache \
      ca-certificates \
      libc6-compat \
      libstdc++ \
      git \
      nodejs \
      asciidoctor \
      py3-pygments && \
    update-ca-certificates

# make sure everything's still okay
RUN hugo version

ENTRYPOINT ["hugo"]
