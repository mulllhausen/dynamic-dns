#!/bin/bash

# do a http request to the intermediary with a one-time hash and see in the
# querystring and the intermediary will be able to figure out this server's ip
# address

# change this password otherwise anybody will be able to set your server's ip
# address
pw="a long string of random characters $%^$%^(f@S!<>"

# the seed is the current unixtime - the intermediary will only accept each seed
# once
seed=$(date +%s)
hex_hash=$(echo -n $seed$pw | openssl sha1 -hmac "key")

# some versions of openssl prepend the string, "(stdin)= " - strip this off if
# it exists
hex_hash=$(echo $hex_hash | sed "s/^.* //")

# make sure to use a https intermediary to avoid man-in-the-middle attacks
wget -q -O- "https://intermediary.com/intermediary_ip.php?action=update&seed="\
"$seed&hash=$hex_hash"

exit $?
