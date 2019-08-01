#!/bin/bash

#### namespace作成
kubectl create namespace php-720-sample

#### namespace切り替え
kubectl config set-context docker-desktop --namespace=php-720-sample

#### ＜DBのpvc構築＞
cd /mnt/c/k8s/php-720-sample/1.db-disk
kubectl apply -f 1.PersistentVolume.yaml
kubectl apply -f 2.PersistentVolumeClaim.yaml

#### secretの作成
##### キーの作成は以下のようにして行う
##### echo -n "database_user" | base64
##### echo -n "database_password" | base64
##### echo -n "secret_key_base" | base64
kubectl apply -f 3.php-apache-psql-secret.yaml

#### ＜src-deployのpvc構築＞
cd /mnt/c/k8s/php-720-sample/2.src-deploy-disk

#### PersistentVolumeの構築
kubectl apply -f 1.PersistentVolume.yaml

#### PersistentVolumeClaimの構築
kubectl apply -f 2.PersistentVolumeClaim.yaml

#### ＜postgreSQL構築＞
##### postgreSQLイメージビルド
cd /mnt/c/k8s/php-720-sample/3.db-rebuild
./skaffold_run.sh

#### ＜php構築＞
##### phpイメージビルド
cd /mnt/c/k8s/php-720-sample/4.php-rebuild
./skaffold_run.sh

#### ＜apache構築＞
##### apacheイメージビルド
cd /mnt/c/k8s/php-720-sample/5.apache-rebuild
./skaffold_run.sh

#### ＜mailsv構築＞
##### mailsvイメージビルド
cd /mnt/c/k8s/php-720-sample/6.mailsv-rebuild
kubectl apply -f ./k8s-mailsv-sv.yaml

#### ＜ingressを構築＞
##### Ingress Controllerの作成
##### 参考サイト：https://kubernetes.github.io/ingress-nginx/deploy/
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml
cd /mnt/c/k8s/php-720-sample/7.ingress

#### sslの鍵登録 ※HTTPSを使用する際は実施
##### kubectl create secret tls example1.co.jp --key ../5.apache-rebuild/ssl/example1.co.jp/svrkey-sample-empty.key --cert ../5.apache-rebuild/ssl/example1.co.jp/svrkey-sample-empty.crt

#### Ingressの作成
kubectl apply -f 80.ingress.yaml

