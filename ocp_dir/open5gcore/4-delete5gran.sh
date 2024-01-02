#!/usr/bin/env bash
echo -e "Wiping UERANSIM....\n"
echo "Project to be used $1"
oc project $1
cd $2/open5gcore/5gran
rm amf-ip
echo "Removing UERANSIM Deployment"
#rm templates/5gran-gnb-configmap.yaml
helm template ueransim-gnb ./ -n $1 --dry-run > ueran-remove.yaml
oc delete -f ueran-remove.yaml
rm ueran-remove.yaml
echo "Uninstall completed. Bye"
