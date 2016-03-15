echo -n "  - " >> /var/www/html/coreos/pxe-cloud-config.yml
cat ansible.rsa.pub >> /var/www/html/coreos/pxe-cloud-config.yml
<<<<<<< HEAD
cp ansible.rsa.pub /vagrant
mv ansible.rsa* .ssh/
=======
mv ansible.rsa* .ssh/
>>>>>>> 4bdead4... Adding vagrant changes to build the boot machine
