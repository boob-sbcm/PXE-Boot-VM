#Generated by Kickstart Configurator
#platform=x86

#System language
lang en_US
#Language modules to install
langsupport en_US
#System keyboard
keyboard us
#System mouse
mouse
#System timezone
timezone America/New_York
#Root password
rootpw --disabled
#Initial user
user ubuntu --fullname "ubuntu" --iscrypted --password $1$L0UCU.Wa$ZnuJgODyfuJMHYDbmnolz1
#Reboot after installation
reboot
#Use text mode install
text
#Install OS instead of upgrade
install
#Use Web installation
url --url http://192.168.2.2x/images/mini_ubuntu_32.iso
#System bootloader configuration
bootloader --location=none
#Clear the Master Boot Record
zerombr yes
#Partition clearing information
clearpart --all 
#System authorization infomation
auth  --useshadow  --enablemd5 
#Network information
network --bootproto=dhcp --device=eth0
network --bootproto=dhcp --device=eth1
#Firewall configuration
firewall --disabled 
#Do not configure the X Window System
skipx
