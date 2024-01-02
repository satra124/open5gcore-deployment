#!/bin/bash
echo "Checking machine config exists on nodes for specific node roles worker"
worker_sctp=`oc get machineconfig|grep enablesctp-worker|wc -l`
  if [ $worker_sctp -eq 1 ]
  then
		echo "SCTP module exists. Moving to CNF deployment"
  else
		echo "Enabling SCTP on worker nodes after checking for required labels"
		node_cnt=`oc get nodes -l machineconfiguration.openshift.io/role=worker -o=jsonpath='{.items[*].metadata.name}'|wc -l`
		if [ $node_cnt -eq 0 ]
		then
		 for i in `oc get nodes -l node-role.kubernetes.io/worker= -o=jsonpath='{.items[*].metadata.name}'`
		 do
		   oc label node $i machineconfiguration.openshift.io/role=worker
		 done
		else
		  echo "Labels exists for worker node"
		fi
		  oc apply -f enablesctp-worker.yaml
  fi