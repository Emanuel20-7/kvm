#!/bin/bash
figlet -c "KVM" -f small
echo -e "\e[34m Start to Create a Machine\e[0m"
echo -e "\e[32m Enter the name for vm\e[0m"
read vmname
sleep 3
virsh list --all
sleep 5
mkdir /storage/$vmname && cd /storage/$vmname && /usr/bin/virt-builder ubuntu-18.04  --install 'git,ssh,openssh-server,wget,curl,vim' --firstboot-command 'dpkg-reconfigure openssh-server' --run-command 'useradd -m -p "" username -s /bin/bash ; chage -d 0 username' --run-command  'usermod -aG sudo username' --run-command "echo 'export LC_ALL="en_US.UTF-8"' >> ~/.bashrc" --firstboot-command 'dhclient' --root-password password:YOURPASSWORD --ssh-inject username:file:/root/.ssh/id_rsa.pub --format qcow2 --size 40G --hostname $vmname   --arch x86_64 
sleep 200
echo -e "\e[34m Check if disk is created\e[0m"
if [ -a ubuntu-18.04.qcow2 ]; then 
     echo -e "\e[34mCreating ....\e[0m"
     virt-install  --name $vmname  --ram 1028 --vcpus=2 --disk path=/vms-storage/$vmname/ubuntu-18.04.qcow2  --metadata description="Creating vm for Ubuntu  with virt-builder" --network bridge=virbr0 --graphics vnc,port=5906 --os-variant ubuntu18.04  --import 
fi 
virsh list --all
figlet "Machine was created"
echo -e "\e[32m Get ip for vm\e[0m"
virsh net-dhcp-leases --network default
exit
