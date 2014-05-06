#!/bin/bash

# compare the server's current ip address to the previous ip address.
# if it is the same then exit.
# if it is different then inform the intermediary.

set -x # print each line
trap read debug # wait for return on each line

inform_intermediary()
{
	curl -G --data-urlencode "ip=$current_ip" \
	https://intermediary.com/intermediary_ip.php
}

# backup the current external ip
if [ -f "/tmp/my_external_ip.txt" ]; then
	previous_ip="$(cat /tmp/my_external_ip.txt)"
	echo "$previous_ip" > /tmp/my_previous_external_ip.txt
else
	previous_ip=""
fi

# retrieve the new current external ip
wget -q -O /tmp/my_external_ip.txt http://ipecho.net/plain

# retrieve the current server external ip according to the intermediary
wget -q -O /tmp/intermediary_ip.txt https://intermediary.com/intermediary_ip.php
intermediary_ip=$(cat /tmp/intermediary_ip.txt)

current_ip="$(cat /tmp/my_external_ip.txt)"
if [ "$current_ip" != "$previous_ip" ]; then
	# the external ip address has changed - inform the intermediary
	inform_intermediary
	exit $?
fi

if [ "$current_ip" != "$intermediary_ip" ]; then
	# the intermediary does not know my ip address - inform it now
	inform_intermediary
	exit $?
fi

# relay error status
exit $?
