FROM alpine:3.23

RUN apk add --no-cache busybox bash tini vim frr
COPY vimrc /root/.vimrc
COPY script /

ENTRYPOINT ["/sbin/tini", "--"]


CMD ["/script"]
