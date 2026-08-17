FROM alpine:3.23

RUN apk add --no-cache busybox bash tini vim frr frr-pythontools
COPY vimrc /root/.vimrc

ENTRYPOINT ["/sbin/tini", "--"]


RUN sed -i 's/zebra=no/zebra=yes/g' /etc/frr/daemons && \
    sed -i 's/ospfd=no/ospfd=yes/g' /etc/frr/daemons && \
    sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons && \
    sed -i 's/isisd=no/isisd=yes/g' /etc/frr/daemons

CMD /usr/lib/frr/frrinit.sh start && exec sh 
