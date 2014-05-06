#!/bin/bash

# this script gets the external ip address of the server.

# -q = quiet
# -O = output file
wget -q -O /tmp/my_external_ip.txt http://ipecho.net/plain
