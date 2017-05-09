#!/bin/bash

mkdir /var/run/openvswitch

if [ ! -f /etc/openvswitch/vtep.db ]; then
    ovsdb-tool create /etc/openvswitch/vtep.db /usr/share/openvswitch/vtep.ovsschema
fi

if [ ! -f /etc/openvswitch/vswitch.db ]; then
ovsdb-tool create /etc/openvswitch/vswitch.db /usr/share/openvswitch/vswitch.ovsschema
fi

ovsdb-server --pidfile --detach --log-file \
             --remote ptcp:6632:${MGMTIPV4} \
             --remote punix:/var/run/openvswitch/db.sock \
             --remote=db:hardware_vtep,Global,managers \
             /etc/openvswitch/vswitch.db /etc/openvswitch/vtep.db

ovs-vswitchd --log-file --detach --pidfile unix:/var/run/openvswitch/db.sock

ovs-vsctl add-br myphyswitch

vtep-ctl add-ps myphyswitch
vtep-ctl set Physical_Switch myphyswitch tunnel_ips=${MGMTIPV4}
ovs-vsctl add-port myphyswitch ${INTF}
vtep-ctl add-port myphyswitch ${INTF}

/usr/share/openvswitch/scripts/ovs-vtep --log-file=/var/log/openvswitch/ovs-vtep.log --pidfile=/var/run/openvswitch/ovs-vtep.pid --detach myphyswitch

sleep infinity

