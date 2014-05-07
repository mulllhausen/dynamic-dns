#!/bin/bash

# send a http request to the intermediary (with a hmac in the query-string) to
# inform the intermediary of this server's ip address

# change this password otherwise anybody will be able to set your server's ip
# address. make sure to also change it in files client.sh and
# intermediary_ip.php
pw='a long string of random characters $%^$%^(f@S!<>'

# the salt is the current unixtime - the intermediary will only accept each salt
# once
salt=$(date +%s)

# use the php sha1 function to simply match the intermediary result
hex_hash=$(echo "<?php echo sha1('$salt$pw'); ?>" | php)

# make sure to use a https intermediary to avoid man-in-the-middle attacks
url="https://www.adofms.com.au/mulll-dynamic-dns/intermediary_ip.php?action="\
"update&salt=$salt&hash=$hex_hash"

# remove the -q flag and run this script manually (./server.sh) to debug
wget -qO /tmp/mulll-dynamic-dns.log "$url"

exit $?
