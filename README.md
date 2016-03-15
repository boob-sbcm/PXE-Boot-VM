#Gemini PXE Boot Machine 

##**Steps**
1. Create "build" images
2. Package "build" images
3. Add image to vagrant
4. Gemini Env Ready

##Setup

- Create the master image. (It sets up dhcp, apache, tftp)

    `vagrant up build_master`

- Package up the current image

    ```
    vagrant package build_master --output <storage_path>/gemini_master.box
    ```
    
- Add to vagrant's box list
    
    ```
    vagrant box add pxe_boot <storage_path>/gemini_master.box
    ```
    
- Destroys the build boxes
    
    `vagrant destroy -f`

- Will deploy from the pre-made images, much faster than before for any future tests
    
    `vagrant up`

##Bring up machines

    ```./cluster.sh -c 3 -n```
    
- Brings up 3 machines, with NATNetwork enabled

##Comments
    
- Will PXE boot CoreOS
- Might need to restart created nodes because tftp timeouts with too many machines to provision.
