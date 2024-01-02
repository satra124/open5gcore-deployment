#!/usr/bin/env bash
#oc new-project open5gran
#oc adm policy add-scc-to-user anyuid -z default -n open5gran
#oc adm policy add-scc-to-user hostaccess -z default -n open5gran
#oc adm policy add-scc-to-user hostmount-anyuid -z default -n open5gran
#oc adm policy add-scc-to-user privileged -z default -n open5gran
current_dir=$2
cd $current_dir/open5gcore/5gran
## gNB Section
echo "Preparing gNB config"
sleep 20
oc get services -n $1 | grep $1-amf-ngap | awk '{print $3}' > amf-ip
echo "AMF IP:" && cat amf-ip
cp resources/gnb.bak resources/gnb.yaml
#cp templates/5gran-gnb-configmap.bak templates/5gran-gnb-configmap.yaml
#cp templates/5gran-ue-configmap.bak templates/5gran-ue-configmap.yaml
#sed -e "s/172.30.173.105/$(<amf-ip sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g" -i templates/5gran-gnb-configmap.yaml
AMF_IP=`cat amf-ip`
#echo $AMF_IP
sed -i -e "s/ADDRESS/$AMF_IP/g" resources/gnb.yaml 
#echo "gNB Config:" && cat templates/5gran-gnb-configmap.yaml
helm install -f values.yaml ueransim-gnb ./
echo "Enjoy The 5GRAN!"
