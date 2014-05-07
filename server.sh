#!/bin/bash

# do a http request to the intermediary with a one-time hash and see in the
# querystring and the intermediary will be able to figure out this server's ip
# address

# change this password otherwise anybody will be able to set your server's ip
# address
pw="a long string of random characters $%^$%^(f@S!<>"

# the salt is the current unixtime - the intermediary will only accept each salt
# once
salt=$(date +%s)

# use the php sha1 function to simply match the intermediary result
hex_hash=$(echo "<?php echo sha1('$salt$pw'); ?>" | php)

# some versions of openssl prepend the string, "(stdin)= " - strip this off if
# it exists
hex_hash=$(echo $hex_hash | sed "s/^.* //")

# make sure to use a https intermediary to avoid man-in-the-middle attacks
url="https://intermediary.com/mulll-dynamic-dns/intermediary_ip.php?action="\
"update&salt=$salt&hash=$hex_hash"

# remove the -q flag and run this script manually (./server.sh) to debug
wget -qO /tmp/mulll-dynamic-dns.log "$url"

exit $?
