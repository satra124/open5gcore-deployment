#!/bin/bash
input="6-insert_Imsi_into_db.txt"
array=[]
while IFS= read -r line
do
  array[${#array[*]}]="$line"
done < $3/open5gcore/"$input"
for i in "${array[@]}"
do
  kubectl exec -it -n $1 pod/$2 -- $i
# or do whatever with individual element of the array
done
