#!/bin/bash

if [[ "$6" == "ngs" ]]; then
   ip r a 192.168.0.0/16 dev ppp0
   ip r a 172.28.0.0/16 dev ppp0
   ip r a 172.16.0.0/16 dev ppp0
fi