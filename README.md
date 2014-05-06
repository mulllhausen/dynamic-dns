dynamic-dns
===========

these scripts resolve a domain name to a changing ip address without the need
to pay for a similar service. you will need a web-accessible website to store
the ip address and act as intermediary.

an example use-case might be to access ssh on your home-pc while at work. if
your isp has allocated a static ip to your home network then you will not need
this project - you could simply go ssh me@123.123.123.123. however if your isp
allocates a dynamic ip address then this will not work once the ip address
changes, and you will need to use this project or else some other service like
dyndns.org (which is no longer free) to do the job for you.

in this project:
- "server" refers to the machine being accessed (eg the webserver or ssh server
that you want to connect to)
- "client" refers to the machine which is connecting
- "intermediary" refers to the machine which stores the server ip address and
relays it to the client upon request


this project was developed for debian/ubuntu but could be made to run on any
flavor of linux.


server setup
----------

     cd /usr/share/
     sudo git clone git@github.com:mulllhausen/dynamic-dns.git mulll-dynamic-dns

add a line to /etc/crontab to run the server.sh script every minute:

     */1 * * * * root /usr/share/mulll-dynamic-dns/server.sh


client setup
----------

     cd /usr/share/
     sudo git clone git@github.com:mulllhausen/dynamic-dns.git mulll-dynamic-dns

add a line to /etc/crontab to run the client.sh script every minute:

     */1 * * * * root /usr/share/mulll-dynamic-dns/client.sh

work in progress :P
===========
