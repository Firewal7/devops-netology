#!/bin/bash

docker run --name ubuntu -d eclipse/ubuntu_python sleep 20000000
docker run --name centos7 -d centos:7 sleep 10000000
docker run --name fedora -d dokken/fedora-34 sleep 65000000

ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass

sleep 5 && docker stop ubuntu centos7 fedora
