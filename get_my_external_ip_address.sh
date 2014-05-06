#!/bin/bash

# this script gets the external ip address of the current server.
# it should be run on the network which is to be accessed from the internet
# (ie run it on the webserver or ssh server machine)

# on debian/ubuntu, run it automatically once every minute by putting the
# following entry in /etc/crontab:
# */1 * * * * root get_my_external_ip_address.sh

# -q = quiet
# -O = output file
wget -q -O /tmp/my_external_ip.txt http://ipecho.net/plain
