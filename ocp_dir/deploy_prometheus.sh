#!/bin/bash
path=`find . -name "ocp_dir" -type d`
cd $path
oc new-project $1 && oc project $1
cp prometheus/values.bak prometheus/values.yaml
amf_svc_ip=`oc get svc -n $2|grep amf-metrics|awk '{print $3}'`
smf_svc_ip=`oc get svc -n $2|grep smf-metrics|awk '{print $3}'`
pcf_svc_ip=`oc get svc -n $2|grep pcf-metrics|awk '{print $3}'`
upf_svc_ip=`oc get svc -n $2|grep upf-metrics|awk '{print $3}'`
mongo_svc_ip=`oc get svc -n $2|grep mongodb-metrics|awk '{print $3}'`
sed -i -e "s/ADDRESS1/$amf_svc_ip/g" prometheus/values.yaml
sed -i -e "s/ADDRESS2/$smf_svc_ip/g" prometheus/values.yaml
sed -i -e "s/ADDRESS3/$pcf_svc_ip/g" prometheus/values.yaml
sed -i -e "s/ADDRESS4/$upf_svc_ip/g" prometheus/values.yaml
sed -i -e "s/ADDRESS5/$mongo_svc_ip/g" prometheus/values.yaml
helm install $1 -n $1 prometheus/
oc delete project $1
