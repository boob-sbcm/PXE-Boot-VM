sudo apt-get install -y apache2
mkdir /var/www/images/
cp /vagrant/provision_files/test.txt /var/www/images/test.txt
cp /netboot/mini_ubuntu_32.iso /var/www/images/my_ubuntu_32.iso
cp /netboot/ubuntu-installer/i386/linux /var/www/images/linux
cp /netboot/my_ks.cfg /var/www/my_ks.cfg
sudo chmod 777 -R /var/www
sudo chown -R nobody /var/www
