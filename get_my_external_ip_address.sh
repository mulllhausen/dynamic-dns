#!/bin/bash

# this script gets the external ip address of the current server
# it should be run on the network which is to be accessed from the internet
# (eg the webserver or ssh server)

# -q = quiet
# -O = output file
wget -q -O /tmp/my_external_ip.txt http://ipecho.net/plain
