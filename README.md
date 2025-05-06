# ansible

Manage my ubuntu configuration

https://opensource.com/article/18/3/manage-workstation-ansible
https://docs.ansible.com/ansible/latest/modules/apt_module.html

## Install Ansible
sudo apt-get install software-properties-common  
sudo apt-add-repository ppa:ansible/ansible  
sudo apt-get update  
sudo apt-get install ansible  

## Execute a playbook file
sudo ansible-pull -U https://github.com/cerbaire/ansible.git  
ansible-playbook -i inventory playbooks/main.yaml  
ansible-playbook -i inventory.ini devops_setup.yml
