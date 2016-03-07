#Vagrant PXE Boot Machine 

##**Steps**
1. Create "build" images
2. Package "build" images
3. Add image to vagrant
4. Have a pxe VM ready to go 

##Setup

- Create the master image. (It sets up dhcp, apache, tftp)

    `vagrant up build_boot`

- Package up the current image

    ```
    vagrant package build_boot --output <storage_path>/pxe_boot.box
    ```
    
- Add to vagrant's box list
    
    ```
    vagrant box add pxe_boot <storage_path>/pxe_boot.box
    ```
    
- Destroys the build boxes
    
    `vagrant destroy -f`

- Will deploy from the pre-made images, much faster than before for any future tests
    
    `vagrant up`

##Test PXE

1. Create a blank VM
2. Enable Network Boot
    a. System Settings -> Motherboard -> Boot Order (Check Network)
3. Update Network Interfaces
    a. Network Settings -> Adapter 1: 
        - Internal Network
        - Name : prov
    b. Network Settings -> Adapter 2:
        - NAT Network
        - Name: NAT Network
4. Start Machine : Will PXE boot and install Ubuntu onto the disk