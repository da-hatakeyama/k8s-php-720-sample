@echo off

kubectl config set-context docker-for-desktop --namespace=php-720-sample  
kubectl port-forward postgresql-0 5432:5432

@echo on
