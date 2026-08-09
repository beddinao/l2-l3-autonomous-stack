FROM alpine:3.23

RUN apk add --no-cache busybox bash tini vim xfce4-terminal
COPY vimrc /root/.vimrc
COPY ht-init.sh /

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/ht-init.sh"]
