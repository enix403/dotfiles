#!/usr/bin/env bash

# Delete tap0 if it exists
if ip link show tap0 &> /dev/null; then
    sudo ip link delete tap0
fi

sudo ip tuntap add dev tap0 mode tap
sudo brctl addif podman0 tap0
sudo ip link set tap0 up

