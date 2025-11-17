#!/bin/bash
# Inventario dinámico en formato JSON válido para Ansible

# Obteniendo las IP en formato JSON (lista)
IPS=$(terraform output -json ip_para_spring-boot | jq -r '.[]')

echo '{'
echo '  "springboot": {'
echo '    "hosts": ['
      FIRST=1
      for ip in $IPS; do
        if [ $FIRST -eq 1 ]; then
          echo "      \"$ip\""
          FIRST=0
        else
          echo "      , \"$ip\""
        fi
      done
echo '    ],'
echo '    "vars": {'
echo '      "ansible_user": "ubuntu",'
echo '      "ansible_ssh_private_key_file": "/home/rusok/Documentos/DevOps/ejemploTerraform/clasesdevops.pem"'
echo '    }'
echo '  }'
echo '}'
