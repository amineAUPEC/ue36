sed -E -i.SAVE \
's/^net.ipv4.ip_forward/#net.ipv4.ip_forward/' \
/etc/sysctl.conf