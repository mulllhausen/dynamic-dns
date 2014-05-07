dynamic-dns
===========

these scripts resolve a domain name to a changing ip address without the need
to pay for a similar service. you will need a web-accessible website with a
domain name or fixed ip to store the server's ip address and act as
intermediary.

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


this project was developed for debian/ubuntu but can be made to run on any
flavor of linux.


server setup
----------

     sudo apt-get install wget
     cd /usr/share/
     sudo git clone git://github.com/mulllhausen/dynamic-dns.git \
     mulll-dynamic-dns

     # add a line to /etc/crontab to run the server.sh script every minute:
     */1 * * * * root /usr/share/mulll-dynamic-dns/server.sh

     # edit the wget url host in the server.sh script - change
     # intermediary.com to the hostname of your intermediary server


intermediary setup
----------

     cd /usr/share/
     sudo git clone git://github.com/mulllhausen/dynamic-dns.git \
     mulll-dynamic-dns
     cd mulll-dynamic-dns/

     # remove everything except intermediary_ip.php:
     sudo rm LICENSE README.md server.sh client.sh

set up your favourite webserver with php to run the intermediary_ip.php upon
request, eg for apache:

     sudo apt-get install apache2 php5 libapache2-mod-php5

     # now add the following lines to /etc/apache2/sites-enabled/000-default
     # between the <virtualhost></virtualhost> tags. use the *:443 virtualhost
     # to avoid man-in-the-middle attacks:

     alias /mulll-dynamic-dns/ "/usr/share/mulll-dynamic-dns/"
     <directory "/usr/share/mulll-dynamic-dns/">
       allow from all
     </directory>


client setup
----------

     cd /usr/share/
     sudo git clone git://github.com/mulllhausen/dynamic-dns.git \
     mulll-dynamic-dns

     # add a line to /etc/crontab to run the client.sh script every minute:
     */1 * * * * root /usr/share/mulll-dynamic-dns/client.sh

work in progress :P
===========
