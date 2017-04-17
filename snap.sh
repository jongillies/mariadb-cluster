#!/bin/bash

for machine in `ls .vagrant/machines`
do
    VM_ID=`cat .vagrant/machines/$machine/virtualbox/id`
    echo "Snapshotting $machine @ $VM_ID..."
    VBoxManage snapshot $VM_ID take base --live
done
