#!/bin/bash

kubectl config set-context docker-for-desktop --namespace=php-720-sample  

kubectl delete -f k8s-db-sv.yaml

if [[ -f ../1.db-disk/storage/php-apache-mysql-data.img ]]; then
    rm -rf ../1.db-disk/storage/php-apache-mysql-data.img
fi
