#!/bin/bash

# N is the number of Elastic Network Interfaces (ENI) of the instance type
# M is the number of IP addresses of a single ENI
# K kubeconfig path

while getopts n:m:k: flag
do
    case "${flag}" in
        n) interfaces=${OPTARG};;
        m) addresses=${OPTARG};;
        k) kubeconfig=${OPTARG};;
    esac
done

if [ -z "$kubeconfig" ]
then
   exit
fi
if [ -z "$interfaces" ] || [ -z "$addresses" ]
then
   exit
fi

pods=$(kubectl --kubeconfig="$kubeconfig" get pods --field-selector=status.phase=Running --all-namespaces -o json | jq '.items | length')

# N * (M - 1) + 2
num=$(($interfaces * ($addresses-1) + 2))

echo $((num - pods))