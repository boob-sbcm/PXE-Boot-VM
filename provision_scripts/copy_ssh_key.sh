echo -n "  - " >> /var/www/html/coreos/pxe-cloud-config.yml
cat ansible.rsa.pub >> /var/www/html/coreos/pxe-cloud-config.yml
mv ansible.rsa* .ssh/