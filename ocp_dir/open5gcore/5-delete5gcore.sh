#!/usr/bin/env bash
echo -e "World is About to End!....\n"
echo "Project to be used $1"
oc project $1
oc delete secret mongodb-ca
cd $2/open5gcore/5gcore
echo "Removing Open5GCore"
#helm uninstall istio-base istio/base -n istio-system
#helm uninstall istiod istio/istiod -n istio-system --wait
#helm uninstall istio-ingressgateway istio/gateway -n istio-system
#kubectl delete namespace istio-system
#kubectl delete namespace istio-ingress
helm template $1 ./ -n $1 --dry-run > core-remove.yaml
oc delete -f core-remove.yaml
rm core-remove.yaml
oc delete project $1
echo "The End"
