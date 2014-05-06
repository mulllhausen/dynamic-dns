#!/bin/bash

# compare the server's current ip address to the previous ip address.
# if it is the same then exit.
# if it is different then inform the intermediary.

# set -x # debug - print each line
# trap read debug # debug - wait for stdin return on each line

intermediary_url="$(cat /usr/share/mulll-dynamic-dns/intermediary_path.txt)"\
"/intermediary_ip.php"

inform_intermediary()
{
	curl -G --data-urlencode "ip=$current_ip" "$intermediary_url"
}

# backup the current external ip
if [ -f "/tmp/my_external_ip.txt" ]; then
	previous_ip="$(cat /tmp/my_external_ip.txt)"
	echo "$previous_ip" > /tmp/my_previous_external_ip.txt
else
	previous_ip=""
fi

# retrieve the new current external ip
current_ip=$(wget -q -O- http://ipecho.net/plain)

# if the external ip address has changed
if [ "$current_ip" != "$previous_ip" ]; then
	# first save the new value
	echo "$current_ip" > /tmp/my_external_ip.txt

	# then inform the intermediary
	inform_intermediary

	exit $?
fi

# retrieve the current server external ip according to the intermediary
intermediary_ip=$(wget -q -O- "$intermediary_url")
echo "$intermediary_ip" > /tmp/intermediary_ip.txt

if [ "$current_ip" != "$intermediary_ip" ]; then
	# the intermediary does not know my correct ip address - inform it now
	inform_intermediary
	exit $?
fi

# relay error status
exit $?
