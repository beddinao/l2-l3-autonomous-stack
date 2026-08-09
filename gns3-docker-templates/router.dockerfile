FROM alpine:3.23

RUN apk add --no-cache busybox bash tini vim frr
COPY vimrc /root/.vimrc
COPY rt-init.sh /

ENTRYPOINT ["/sbin/tini", "--"]


CMD ["/rt-init.sh"]
