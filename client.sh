#!/bin/bash

# version 1.0

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

# remove the -q flag and run this script manually (./client) to debug
server_ip=$(wget -qO- "$url")
# remove all spaces:
server_ip=$(echo $server_ip | tr -d " ")

# get the previous known ip address
if [ -f "/tmp/mulll-dynamic-dns-server-ip" ]; then
	previous_server_ip=$(cat /tmp/mulll-dynamic-dns-server-ip)
else
	previous_server_ip=""
fi

if [ ! -z "$server_ip" ] && [ "$server_ip" == "$previous_server_ip" ]; then
	echo "there was no change in the server ip address"
	exit 0
fi

# change this to the fqdn of your remote server. be careful not to call it
# 'localhost' since any lines containing this value are going to be deleted from
# /etc/hosts !!!
server_hostname="mulllhausen.com"

# delete the line containing the server hostname from /etc/hosts
sed "/$server_hostname/d" /etc/hosts > /tmp/mulll-dynamic-dns-hosts

# append the new ip address and hostname
echo "$server_ip $server_hostname" >> /tmp/mulll-dynamic-dns-hosts

# overwrite /etc/hosts with /tmp/mulll-dynamic-dns-hosts
mv /tmp/mulll-dynamic-dns-hosts /etc/hosts

echo "$server_ip" > /tmp/mulll-dynamic-dns-server-ip

exit $?
