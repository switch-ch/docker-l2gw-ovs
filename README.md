# Build

    docker build

# Run

    docker run --net=host \
           --cap-add NET_ADMIN \
           --env MGMTIPV4=127.0.0.1 \
           --env INTF=ens5  \
           -v /etc/openvswitch:/etc/openvswitch \
           zioproto/docker-l2gw-ovs
