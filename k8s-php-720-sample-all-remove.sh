#!/bin/bash

#### ＜DBのpvc構築＞
cd /mnt/c/k8s/php-720-sample/1.db-disk
kubectl delete -f 1.PersistentVolume.yaml
kubectl delete -f 2.PersistentVolumeClaim.yaml

#### secretの作成
##### キーの作成は以下のようにして行う
##### echo -n "database_user" | base64
##### echo -n "database_password" | base64
##### echo -n "secret_key_base" | base64
kubectl delete -f 3.php-apache-psql-secret.yaml

#### ＜src-deployのpvc構築＞
cd /mnt/c/k8s/php-720-sample/2.src-deploy-disk

#### PersistentVolumeの構築
kubectl delete -f 1.PersistentVolume.yaml

#### PersistentVolumeClaimの構築
kubectl delete -f 2.PersistentVolumeClaim.yaml

#### ＜postgreSQL構築＞
##### postgreSQLイメージビルド
cd /mnt/c/k8s/php-720-sample/3.db-rebuild
kubectl delete -f k8s-db-sv.yaml

#### ＜php構築＞
##### phpイメージビルド
cd /mnt/c/k8s/php-720-sample/4.php-rebuild
kubectl delete -f k8s-php-dp-sv.yaml

#### ＜apache構築＞
##### apacheイメージビルド
cd /mnt/c/k8s/php-720-sample/5.apache-rebuild
kubectl delete -f k8s-apache-sv.yaml

#### ＜mailsv構築＞
##### mailsvイメージビルド
cd /mnt/c/k8s/php-720-sample/6.mailsv-rebuild
kubectl delete -f ./k8s-mailsv-sv.yaml

#### sslの鍵登録 ※HTTPSを使用する際は実施
##### kubectl create secret tls d-a.co.jp

cd /mnt/c/k8s/php-720-sample/7.ingress
#### Ingressの作成
kubectl delete -f 80.ingress.yaml

#### namespace切り替え
kubectl config set-context docker-for-desktop --namespace=default

#### namespace作成
kubectl delete namespace php-720-sample
