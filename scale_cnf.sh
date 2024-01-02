#!/bin/bash

user_input=$1
token=$2
server=$3
cnf_name=$4

set -e
if [ -z $token ]
then
   echo "Login to OC Cli cannot continue. No token details provided."
   exit 1
fi
if [ -z $server ]
then
   echo "Login to OC Cli cannot continue. No server details provided."
   exit 1
fi
oc login --token=$token --server=$server --insecure-skip-tls-verify=true
echo "Logged into the cluster"
cwd=`find . -name "ocp_dir" -type d`
if [ -z $cwd ]
then
  echo "ocp_dir doesnot exist or not accessible. Cannot continue"
  exit 1
fi
if [ -z $user_input ]
then
  echo "User input should be either scale-in or scale-out and its case sensitive. No input"
  exit 1
fi
if [ -z cnf_name ]
then
  echo "Atleast put some part of the cnf name correctly. Nothing provided"
  exit 1
fi
if [ $user_input == 'scale-out' ]
then
  cnf_cnt=`oc get all -A|grep amf|grep -v 'service'|grep -v 'pod'|grep -v 'replicaset'|wc -l`
  if [ $cnf_cnt -eq 0 ]
  then
    echo "CNF doesnot exist in cluster. Only type deployment and statefulset can be scaled"
    exit 1
  else
  namespace=`oc get all -A|grep -i $cnf_name|grep -v 'service'|grep -v 'pod'|grep -v 'replicaset'|awk '{print $1}'`
  cnf_type=`oc get all -A|grep -i $cnf_name|grep -v 'service'|grep -v 'pod'|grep -v 'replicaset'|awk '{print $2}'`
  replicas=`oc get all -A|grep -i $cnf_name|grep -v 'service'|grep -v 'pod'|grep -v 'replicaset'|awk '{print $4}'`
  oc scale $cnf_type -n $namespace --replicas=$(expr $replicas + 1)
  echo "Replicas scaled to $(expr $replicas + 1)"
  fi
elif [ $user_input == 'scale-in' ]
then
  cnf_cnt=`oc get all -A|grep amf|grep -v 'service'|grep -v 'pod'|grep -v 'replicaset'|wc -l`
  if [ $cnf_cnt -eq 0 ]
  then
    echo "CNF doesnot exist in cluster. Only type deployment and statefulset can be scaled"
    exit 1
  else
  namespace=`oc get all -A|grep -i $cnf_name|grep -v 'service'|grep -v 'pod'|grep -v 'replicaset'|awk '{print $1}'`
  cnf_type=`oc get all -A|grep -i $cnf_name|grep -v 'service'|grep -v 'pod'|grep -v 'replicaset'|awk '{print $2}'`
  replicas=`oc get all -A|grep -i $cnf_name|grep -v 'service'|grep -v 'pod'|grep -v 'replicaset'|awk '{print $4}'`
  if [ $replicas -eq 1 ]
  then
    echo "Replicas will become 0 after scale-in. Cannot continue"
    exit 1
  else
    oc scale $cnf_type -n $namespace --replicas=$(expr $replicas - 1)
    echo "Replicas scaled to $(expr $replicas - 1)"
  fi
 fi
else
  echo "Some error in input. Please retry."
  exit 1
fi
