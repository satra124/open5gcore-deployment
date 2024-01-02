#!/usr/bin/env bash
echo -e "Creating Project: $1\n"
echo "Installing in project $1"
oc new-project $1
oc project $1
#echo -e "Adding project to service mesh member-roll\n"
#oc -n istio-system patch --type='json' smmr default -p '[{"op": "add", "path": "/spec/members", "value":["'"open5gcore"'"]}]'
echo -e "Configuring privileged access\n"
echo
oc adm policy add-scc-to-user anyuid -z default 
oc adm policy add-scc-to-user hostaccess -z default 
oc adm policy add-scc-to-user hostmount-anyuid -z default 
oc adm policy add-scc-to-user privileged -z default 
current_dir=$2
echo "Dir: $current_dir"
oc create secret generic mongodb-ca --from-file=$2/open5gcore/5gcore/ca-tls-certificates/rds-combined-ca-bundle.pem
oc get secret
cd $current_dir/open5gcore/5gcore
echo "Deploying Open5G Core"
#helm repo add istio https://istio-release.storage.googleapis.com/charts
#helm repo update
#kubectl create namespace istio-system
#helm install istio-base istio/base -n istio-system --set defaultRevision=default
#helm install istiod istio/istiod -n istio-system --wait
#helm install istio-ingressgateway istio/gateway -n istio-system
helm install -f values.yaml $1 ./
echo "Enjoy The Open 5G Core!"
