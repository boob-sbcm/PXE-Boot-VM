#Gemini Master 
 - Gemini is an open source project started by [Daneyon Hansen] (https://github.com/danehans) which is focused around adding CoreOS support to the [kubernetes/contrib] (https://github.com/kubernetes/contrib) project and creating a platform to enable simple installation and set up of a kubernetes cluster on baremetal.
 - This repository creates the **_Gemini Master_** who will be conducting the installation / configuration of kubernetes on CoreOS nodes. These controlled nodes will be called **_Managed Nodes_**.
 - Managed Nodes fall into two categories
   - **PXE Boot Managed Nodes**: Blank Machines started in virtualbox and put on the *prov* internal network and told to network boot.
   - **Vagrant Boot Managed Nodes**: Base CoreOS machines also put on the *prov* internal network
 - This Repository will only concern itself with the **_Gemini Master_** and the **_PXE Boot Managed Nodes_**, **Vagrant Boot Managed Nodes** can be found on my [coreos-vagrant] (https://github.com/stephenrlouie/coreos-vagrant/tree/gemini) repo.

##Demo
- [Streaming Link] (https://cisco.webex.com/ciscosales/ldr.php?RCID=1685081ad9ff3361b1fcc68ceb24a282)
- [Download Link] (https://cisco.webex.com/ciscosales/lsr.php?RCID=b3fc3aa5faa81d5b5c608cf7199521f9)

##High Level View: 
![alt text] (https://github.com/stephenrlouie/gemini_images/blob/master/high-level.png "High Level View")

- As you can see there are numerous roles the gemini master can assign to Managed Nodes, such as Kube Master, Kube Workers, or Etcd nodes. Each role is specified in the kubernetes/contrib file [inventory file] (https://github.com/kubernetes/contrib/blob/master/ansible/inventory.example.single_master).

##**Overview**
1. Pull pre-requisite images / tars
2. Create "build_master" image
3. Package "build_master" images
4. Add image to vagrant
5. Destroy build_master Image
6. Deploy pre-built Image
7. Pull contrib code
8. Create Managed Nodes
9. Configure inventory file and run contrib/ansible/setup.sh


 - Steps 2-5: Can be skipped but are here to save time for later deployments of the virtual environment.
   - These steps take up to 10 minutes to bring up the Gemini Master because we are yum updating, installing and configuring all the parts of the Gemini Master. By packaging up the image and adding it to Vagrant, the start up time goes from 10 minutes to 30 seconds. *It is highly recommended to package this build.*


##First Time Setup
1. Pull the cent image and tars required for Gemini Master (K8s tar, Flannel Tar)
 - **Time: 5 Minutes**
 
    `cd start_scripts`
    `./start.sh`

2. Create the master image.
 - This step will yum update, install, configure and start httpd, tftp, and dhcp. It creates a gemini master from scratch. 
 - **Time: 5-10 Minutes**

    `vagrant up build_master`

3. Package up the current image
 - This step will take the good image we made in step 2 and package it for later use and faster depoyment.
 - **Time: 1 Minute**

    ```
    vagrant package build_master --output <storage_path>/gemini_master.box
    ```
    
4. Add to vagrant's box list
 - This will take your pre-made image and make it known to Vagrant. You can view the Vagrant images by running `vagrant box list`
 - **Time: 30 Seconds**
    
    ```
    vagrant box add gemini_master <storage_path>/gemini_master.box
    ```
    
5. Destroys the build_master box. (build_master is there to create our *golden image*)
 - **Time: 10 Seconds**
    
    `vagrant destroy -f`

6. Deploys the pre-made image. *Must name the Vagrant reference gemini_master* See [Vagrantfile] (https://github.com/stephenrlouie/PXE-Boot-VM/blob/gemini/Vagrantfile) section for 'master' 
 - **Time: 30 Seconds**
    
    `vagrant up`

7. Pull contrib code
 - The gemini master must have a copy of the contrib project to deploy to managed nodes.
 
   ```
   vagrant ssh master
   git clone https://github.com/stephenrlouie/contrib.git
   git checkout vagrant_ansible_python
   ```
 - *Note this can be your own copy of the contrib project configured to your own specifications*

8. Create Managed Nodes
 1. PXE-Boot Managed Nodes:
   - For more cluster options `./cluster.sh -h`
    
    ```
    cd create_cluster
    ./cluster.sh -c <number_of_nodes> -n -s
    ```
    
 2. Vagrant Boot Managed Nodes
   - See the gemini branch on my [coreos-vagrant] (https://github.com/stephenrlouie/coreos-vagrant/tree/gemini) repo.

9. Configure inventory file and run *contrib/ansible/setup.sh*
 - Both managed node start up methods will bring up machines with pre-selected MAC Addresses.
 
 This table is just a sample; static mapping will continue up to mac 00:00:00:00:0b in the same pattern shown below. See the [DHCP.conf] (https://github.com/stephenrlouie/PXE-Boot-VM/blob/gemini/provision_files/dhcpd.conf) for details.

 |Node Number | MAC Address       | IP          |
 | ---------- | ----------------- | ----------- | 
 | Node-01    | 00:00:00:00:00:01 | 192.168.2.3 |
 | Node-02    | 00:00:00:00:00:02 | 192.168.2.4 |
 | Node-03    | 00:00:00:00:00:03 | 192.168.2.5 |
 | Node-04    | 00:00:00:00:00:04 | 192.168.2.6 |
 
 - An example inventory file might look like [this] (https://gist.github.com/stephenrlouie/94497c7035ff0c07fa6f)
  - You can configure the ssh user in [/contrib/ansible/group_vars/all.yml] (https://github.com/stephenrlouie/contrib/blob/vagrant_ansible_python/ansible/group_vars/all.yml)
  - You can configure the private_key_file in your ansible_cfg at `/etc/ansible/ansible.cfg`.  *private_key_file: /home/vagrant/.ssh/ansible.rsa*
 - Lastly, run the setup.sh script to configure the cluster.
 
 `INVENTORY=inventory ./setup.sh --private-key ~/.ssh/ansible_rsa -u core`


##Testing the Cluster
1. ssh into the kube master node (whoever you assigned it to in your inventory file)
2. Check nodes

 `kubectl get nodes`

3. Create file `web.yml` by copy pasting this [gist] (https://gist.github.com/danehans/cb744bd10084175ccc44)
4. Create the pod, replication controller and service.
 
 `sudo kubectl create -f web.yml`

5. Check status of the pod, rc and service.

 `kubectl get pod,rc,svc`
 
 - Wait until the pod is in the *Running* state (can take up to 5 minutes)
 ![alt text] (https://github.com/stephenrlouie/gemini_images/blob/master/curl_web.png)

6. curl http://*"Service IP Address"* (As seen above)

7. You can hit the web app from your favorite web browser if you expose the NAT port on the kube master node. 
 1. Right click on the kube_master VM in virtualbox 
 2. *Settings* -> *Network* -> *Port Forwarding*. (On the Adapter that is attached to *NAT*)
 3. Add a rule:
    - Protocol: TCP
    - Host Port: 3030
    - Guest Port: 30302
 4. Open a web browser and go to `localhost:3030` or `http://127.0.0.1:3030`

##Refreshing Gemini Master
 1. If you **did** package the gemini_master. Repeat Steps: 6 -> END
 2. If you **did not** package the gemini_master. Repeat Steps: 2 -> END

##Refreshing Managed Nodes
 - PXE Boot Managed Nodes
  - ./cluster.sh -r -c <number_of_nodes> -n
  - `-r` will restart start the nodes
  - Or use the cleanup.sh script
  
 - Vagrant Boot Managed Nodes
  - Go to the [*coreos-vagrant*] (https://github.com/stephenrlouie/coreos-vagrant/tree/gemini) directory where you started the nodes
  
  ```
  vagrant destroy -f
  vagrant up
  ```

 - Repeat step 9 to re-deploy contrib

##Tips
 - Since you'll be cycling through managed nodes for development / testing it might be useful to add this to your profile / bashrc.
 
   `export ANSIBLE_HOST_KEY_CHECKING=False`

##Known Issues
 - See [open issues] (https://github.com/stephenrlouie/PXE-Boot-VM/issues). All work-arounds will be posted under its corresponding issue.
