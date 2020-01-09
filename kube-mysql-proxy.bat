@echo off

kubectl config set-context docker-for-desktop --namespace=php-720-sample  
kubectl port-forward mysql-0 3306:3306

@echo on
