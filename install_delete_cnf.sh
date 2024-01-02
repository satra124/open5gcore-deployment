#!/bin/bash

user_input=$1
token=$2
server=$3
project_cnf=$4
project_monitoring=$5

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
oc login --token=$token --server=$server
echo "Logged into the cluster"
cwd=`find . -name "ocp_dir" -type d`
if [ -z $cwd ]
then
  echo "ocp_dir doesnot exist or not accessible. Cannot continue"   
fi
if [ -z $project_cnf ]
then
   echo "CNF project details not specified in 4th place"
   exit 1
fi
if [ -z $project_monitoring ]
then
   echo "Monitoring project details not specified in 5th place"
   exit 1
fi

if [ -z $user_input ]
then
   echo "User input should be either create or delete and its case sensitive. No input"
fi   
if [ $user_input == 'create' ]
then
   echo "Deploying 5G Core"
   bash $cwd/open5gcore/2-deploy5gcore.sh $project_cnf $cwd
   echo "5GCore Command: $cwd/open5gcore/2-deploy5gcore.sh $project_cnf $cwd"
   echo "Waiting for deployment to complete"
   sleep 30
   echo "Deploy RAN Components"
   bash $cwd/open5gcore/3-deploy5gran.sh $project_cnf $cwd
   echo "5GRan Deployment Command: $cwd/open5gcore/3-deploy5gran.sh $project_cnf $cwd"
   echo "Deploying prometheus: $cwd/deploy_prometheus.sh $project_monitoring"
   bash $cwd/deploy_prometheus.sh $project_monitoring $project_cnf
   sleep 20
   echo "Deployment complete"
   #echo "Inserting 50K IMSIs into DB"
   #echo "Command: $cwd/open5gcore/insert_imsi_into_db.sh $project_cnf"
   #bash $cwd/open5gcore/insert_imsi_into_db.sh $project_cnf
   echo "Setup Complete"
   exit 0
elif [ $user_input == 'delete' ]
then
   echo "Deployment being deleted"
   echo "Removing prometheus and monitoring project"
   bash $cwd/delete_prometheus.sh $project_monitoring
   echo "Command: $cwd/delete_prometheus.sh $project_monitoring"
   echo "Deleting RAN components"
   bash $cwd/open5gcore/4-delete5gran.sh $project_cnf $cwd $project_cnf
   echo "Command: $cwd/open5gcore/4-delete5gran.sh $project_cnf $cwd $project_cnf"
   echo "RAN Components deleted. Deleting 5G Core"
   bash $cwd/open5gcore/5-delete5gcore.sh $project_cnf $cwd
   echo "Command: $cwd/open5gcore/5-delete5gcore.sh $project_cnf $cwd"
   echo "Cluster returned to original state. Please delete the load-sctp-module machine config using cluster-admin sudoer user."
else
   echo "Wrong input"
fi
set +e
exit 0
