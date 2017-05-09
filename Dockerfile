# Run this Docker container like this:
# docker run --net=host --cap-add NET_ADMIN --env MGMTIPV4=127.0.0.1 --env INTF=ens5  -v /etc/openvswitch:/etc/openvswitch zioproto/docker-l2gw-ovs

FROM ubuntu:16.04

MAINTAINER Saverio Proto <saverio.proto@switch.ch>

RUN apt-get update && \
    apt-get -y install iproute2 && \
    apt-get -y install openvswitch-vtep && \
    ovsdb-tool create /etc/openvswitch/vtep.db /usr/share/openvswitch/vtep.ovsschema && \
    ovsdb-tool create /etc/openvswitch/vswitch.db /usr/share/openvswitch/vswitch.ovsschema && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /entrypoint.sh
RUN chown root.root /entrypoint.sh && chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
