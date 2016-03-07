apt-get install -y isc-dhcp-server
cp /vagrant/provision_files/dhcpd.conf /etc/dhcp/dhcpd.conf
cp /vagrant/provision_files/isc-dhcp-server /etc/default/isc-dhcp-server
sudo service isc-dhcp-server restart
