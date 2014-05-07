#!/bin/bash

# send a http request to the intermediary (with a hmac in the query string) to
# get the server's ip address. then update the local dns.

# change this password otherwise anybody will be able to set your server's ip
# address. make sure to also change it in files server.sh and
# intermediary_ip.php
pw='a long string of random characters $%^$%^(f@S!<>'

# the salt is the current unixtime - the intermediary will only accept each salt
# once
salt=$(date +%s)

# use the php sha1 function to simply match the intermediary result
hex_hash=$(echo "<?php echo sha1('$salt$pw'); ?>" | php)

# make sure to use a https intermediary to avoid man-in-the-middle attacks
url="https://intermediary.com/mulll-dynamic-dns/intermediary_ip.php?action="\
"retrieve&salt=$salt&hash=$hex_hash"

# remove the -q flag and run this script manually (./server.sh) to debug
server_ip=$(wget -qO /tmp/mulll-dynamic-dns.log "$url")

#
