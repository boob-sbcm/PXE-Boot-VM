#Gemini Master 
 - Gemini is an open source project started by [Daneyon Hansen] (https://github.com/danehans) which is focused around adding CoreOS support to the [kubernetes/contrib] (https://github.com/kubernetes/contrib) project.
 - This repository creates the **_Gemini Master_** who will be conducting the installation of kubernetes on CoreOS nodes. These nodes will be called **_Managed Nodes_**.
 - Managed Nodes fall into two categories
   - **PXE Boot Managed Nodes**: Blank Machines started in virtualbox and put on the *prov* internal network and told to network boot.
   - **Vagrant Boot Managed Nodes**: Base CoreOS machines also put on the *prov* internal network
 - This Repository will only concern itself with the **_Gemini Master_** and the **_PXE Boot Managed Nodes_**

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

    ```./cluster.sh -c 3```
    
- Brings up 3 machines
- use -h option to see all script args

##Comments
    
- Will PXE boot CoreOS
- Might need to restart created nodes because tftp timeouts with too many machines to provision.
