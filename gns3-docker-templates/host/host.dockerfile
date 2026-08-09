FROM alpine:3.23

RUN apk add --no-cache busybox bash tini vim
COPY vimrc /root/.vimrc

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/bin/bash"]
