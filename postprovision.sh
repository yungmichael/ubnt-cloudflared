#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

# Remove the scheduled task so it runs only once after provision
configure
delete system task-scheduler task postprovision
commit
save
exit

# Pull files
mkdir -p /etc/cloudflared
/usr/bin/curl --fail https://raw.githubusercontent.com/Twanislas/ubnt-cloudflared/master/config.yml --output /etc/cloudflared/config.yml
/usr/bin/curl --fail https://raw.githubusercontent.com/Twanislas/ubnt-cloudflared/master/cloudflared --output /usr/local/bin/cloudflared
/bin/chmod +x /usr/local/bin/cloudflared
/usr/local/bin/cloudflared service install
/etc/init.d/cloudflared start

# Configure the system to use local DNS proxy
configure
delete service dns forwarding options
set service dns forwarding options "no-resolv"
set service dns forwarding options "server=127.0.0.1#5053"
commit
save
exit