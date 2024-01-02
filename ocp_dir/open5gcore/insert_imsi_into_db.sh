#!/bin/bash
set -e
cwd=`find . -name "ocp_dir" -type d`
get_po_name=`kubectl get po -n $1|grep populate|awk '{print $1}'`
if [ -z $get_po_name ]
then
   echo "No POD found. Exiting. Please run the script manually"
   exit 1
else
   echo "Unzipping the script file"
   cp $cwd/open5gcore/6-insert_Imsi_into_db.txt_bkp.gz $cwd/open5gcore/6-insert_Imsi_into_db.txt.gz 
   gunzip $cwd/open5gcore/6-insert_Imsi_into_db.txt.gz
   #echo "Copying script to POD"
   #kubectl cp -n $1 $cwd/open5gcore/6-insert_Imsi_into_db.txt open5gcore/$get_po_name:/
   #kubectl cp -n $1 $cwd/open5gcore/run_imsi_insert.sh open5gcore/$get_po_name:/
   #echo "Copy completed. Start insert into DB."
   #kubectl exec -it pod/$get_po_name -n $1 -- nohup bash run_imsi_insert.sh &
   bash $cwd/open5gcore/run_imsi_insert.sh $1 $get_po_name $cwd
   #cnt=1
   #while [ $cnt -eq 1 ]
   #do
   #  sleep 5
   #  cnt=`kubectl exec -it pod/$get_po_name -n $1 -- ps -ef|grep nohup|grep -v grep|wc -l`
   #done
   sleep 10  
   echo "Subscribers inserted into DB. Check status from webUI"
fi
set +e
