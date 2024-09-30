#!/bin/bash

dnf install ansible -y 
cd /tmp 
git clone https://github.com/santhan29/expense-ansible.git
cd expense-ansible
ansible-playbook -i inventory.ini mysql.yaml 
ansible-playbook -i inventory.ini backend.yaml 
ansible-playbook -i inventory.ini frontend.yaml  