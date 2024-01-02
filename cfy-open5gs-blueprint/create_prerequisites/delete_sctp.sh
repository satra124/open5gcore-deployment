#!/bin/bash

oc delete -f enablesctp-worker.yaml
for i in `oc get nodes -l node-role.kubernetes.io/worker= -o=jsonpath='{.items[*].metadata.name}'`
do
   oc label node $i machineconfiguration.openshift.io/role-
done
echo "Node label removed"
