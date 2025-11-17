#!/bin/bash
echo "[springboot]" > inventory2.ini
terraform output -json ip_para_spring-boot | jq -r '.[]' >> inventory2.ini
echo "[springboot:vars]" >> inventory2.ini
echo "ansible_user=ubuntu" >> inventory2.ini
echo "ansible_ssh_private_key_file=/home/rusok/Documentos/DevOps/ejemploTerraform/clasesdevops.pem" >> inventory2.ini
