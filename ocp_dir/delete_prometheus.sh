#!/bin/bash
path=`find . -name "ocp_dir" -type d`
cd $path
oc project $1
set -e
helm template $1 prometheus/ -n $1 --dry-run > prometheus-delete.yaml 
oc delete -f prometheus-delete.yaml
rm prometheus-delete.yaml
oc delete project $1
set +e
exit 0
