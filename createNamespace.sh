#!/bin/bash

NS=$1
kubectl create namespace $NS
kubectl -n $NS create serviceaccount aerospike-operator-controller-manager
kubectl get clusterrolebindings.rbac.authorization.k8s.io $(kubectl get clusterrolebindings.rbac.authorization.k8s.io -o=json | \
jq '.items | .[].metadata.name' | \
grep -E '\"aerospike-kubernetes-operator.v[0-9]+.[0-9]+.[0-9]+-[a-z0-9]+\"' | \
sed 's/\"//g') -o json | \
jq --arg NS "$NS" '.subjects += [{"kind": "ServiceAccount", "name": "aerospike-operator-controller-manager", "namespace": "'"$NS"'"}]' | \
kubectl replace -f - 
