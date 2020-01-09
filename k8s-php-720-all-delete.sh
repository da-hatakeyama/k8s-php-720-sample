#!/bin/bash

#### namespace切り替え
kubectl config set-context docker-for-desktop --namespace=php-720-sample  

#### ＜postgreSQL削除＞
##### postgreSQLイメージ削除
cd /mnt/c/k8s/php-720-sample/3.psql-rebuild
kubectl delete -f k8s-db-sv.yaml

#### ＜MySQL削除＞
##### MySQLイメージ削除
cd /mnt/c/k8s/php-720-sample/4.mysql-rebuild
kubectl delete -f k8s-db-sv.yaml

#### ＜DNS(bind)削除＞
##### DNS(bind)イメージ削除
cd /mnt/c/k8s/php-720-sample/5.dns
kubectl delete -f k8s-db-sv.yaml

#### ＜php7削除＞
##### php7イメージ削除
cd /mnt/c/k8s/php-720-sample/6.php7-rebuild
kubectl delete -f k8s-php-dp-sv.yaml

##### php5イメージ削除
cd /mnt/c/k8s/php-720-sample/7.php5-rebuild
kubectl delete -f k8s-php-dp-sv.yaml

#### ＜apache削除＞
##### apacheイメージ削除
cd /mnt/c/k8s/php-720-sample/8.apache-rebuild
kubectl delete -f k8s-apache-sv.yaml

#### ＜mailsv削除＞
##### mailsvイメージ削除
cd /mnt/c/k8s/php-720-sample/9.mailsv-rebuild
kubectl delete -f ./k8s-mailsv-sv.yaml

#### ＜DBのpvc削除＞
cd /mnt/c/k8s/php-720-sample/1.db-disk
kubectl delete -f 1.PersistentVolume.yaml
kubectl delete -f 2.PersistentVolumeClaim.yaml

#### secretの削除
##### キーの作成は以下のようにして行う
##### echo -n "database_user" | base64
##### echo -n "database_password" | base64
##### echo -n "secret_key_base" | base64
kubectl delete -f 3.php-apache-psql-secret.yaml

#### ＜src-deployのpvc削除＞
cd /mnt/c/k8s/php-720-sample/2.src-deploy-disk

#### PersistentVolumeの削除
kubectl delete -f 1.PersistentVolume.yaml

#### PersistentVolumeClaimの削除
kubectl delete -f 2.PersistentVolumeClaim.yaml

#### sslの鍵削除 ※HTTPSを使用する際は実施
##### kubectl create secret tls example1.co.jp

cd /mnt/c/k8s/php-720-sample/10.ingress
#### Ingressの削除
kubectl delete -f 80.ingress.yaml

#### namespace切り替え
kubectl config set-context docker-for-desktop --namespace=php-720-sample  

#### namespace削除
kubectl delete namespace php-720-sample
