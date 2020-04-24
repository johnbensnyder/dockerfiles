#! /bin/bash

###################################################
# Setup SSH for instance communication
###################################################

cd

ssh-keygen -t rsa -N "" -f ${HOME}/.ssh/id_rsa

chmod 600 ${HOME}/.ssh/id_rsa

printf "Host *\n\tForwardAgent yes\n\tStrictHostKeyChecking no\n" >> ${HOME}/.ssh/config
printf "\tUserKnownHostsFile=/dev/null\n" >> ${HOME}/.ssh/config
printf "\tLogLevel=ERROR\n\tServerAliveInterval=30\n" >> ${HOME}/.ssh/config
printf "\tUser ubuntu\n" >> ${HOME}/.ssh/config

echo `cat ${HOME}/.ssh/id_rsa.pub` >> ${HOME}/.ssh/authorized_keys~
