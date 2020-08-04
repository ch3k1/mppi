#!/bin/bash

# N is the number of Elastic Network Interfaces (ENI) of the instance type
# M is the number of IP addresses of a single ENI
# K is path of kube config
# I is the number of worker nodes on AWS

while getopts n:m:k:i: flag
do
    case "${flag}" in
        n) interfaces=${OPTARG};;
        m) addresses=${OPTARG};;
        k) kubeconfig=${OPTARG};;
        i) instances=${OPTARG};;
    esac
done

if [ -z "$kubeconfig" ]
then
   kubeconfig=$HOME/.kube/config
fi
if [ -z "$interfaces" ] || [ -z "$addresses" ]
then
   exit
fi

pods=$(kubectl --kubeconfig="$kubeconfig" get pods --field-selector=status.phase=Running --all-namespaces -o json | jq '.items | length')
if [ -z "$instances" ]
then
   num=$(($interfaces * ($addresses-1) + 2))
else
   value=$(($interfaces * ($addresses-1) + 2))
   num=$(($value * $instances))
fi
echo $((num - pods))
