FROM alpine:latest
LABEL maintainer="antonov@perx.ru"
LABEL version="latest"

ARG HUGO_VERSION

COPY ./drone-hugo.sh /bin/

RUN apk update && \
    apk --no-cache add git && \
    chmod +x bin/drone-hugo.sh && \
    mkdir /temp/ && \
    wget -O- https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz | tar xz -C /temp/ && \
    mv /temp/hugo /bin/hugo && \
    rm  -rf /temp

ENTRYPOINT /bin/sh /bin/drone-hugo.sh
