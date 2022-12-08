Login into node:
the eni could not bind to os. kernel driver issue.

workaround:
reboot

# get mac list
curl http://100.100.100.200/latest/meta-data/network/interfaces/macs/
export MAC=00:16:3e:00:ae:40
# get IP address
curl http://100.100.100.200/latest/meta-data/network/interfaces/macs/${MAC}/primary-ip-address
# get netmask
curl http://100.100.100.200/latest/meta-data/network/interfaces/macs/${MAC}/netmask
# get gateway
curl http://100.100.100.200/latest/meta-data/network/interfaces/macs/${MAC}/gateway
