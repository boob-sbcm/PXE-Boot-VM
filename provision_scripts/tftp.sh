apt-get install -y xinetd tftpd tftp
cp /vagrant/provision_files/tftp /etc/xinetd.d/tftp
sudo mkdir /tftpboot
cp /vagrant/provision_files/test.txt /tftpboot/test.txt
cp -R /netboot/* /tftpboot
sudo chmod -R 777 /tftpboot
sudo chown -R nobody /tftpboot
sudo service xinetd restart
