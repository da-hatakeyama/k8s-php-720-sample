＜docker for windows kubernetes使用準備＞
# Docker for Windowsをインストールし、設定画面でkubernetesを有効にする。

# WSLでskaffoldインストール
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
chmod +x skaffold
sudo mv skaffold /usr/local/bin

# WSL(Bash on Windows)でDockerを使用する
# 参考：https://qiita.com/yoichiwo7/items/0b2aaa3a8c26ce8e87fe
#       https://medium.com/@XanderGrzy/developing-for-docker-kubernetes-with-windows-wsl-9d6814759e9f
#       https://www.myzkstr.com/archives/888

# Docker for Windowsの設定で、WSLから使えるようにする。
Setting画面からGeneralタブを開き、Expose daemon on tcp://localhost:2375 without TLSにチェックを入れる。

# 事前パッケージインストール
sudo apt-get install \
    apt-transport-https  ca-certificates curl \
    software-properties-common

# Docker公式のGPG鍵を追加,確認
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

# Dockerレポジトリを追加 (Stableチャンネルのレポジトリ)
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Dockerインストール (Communityエディション)
sudo apt-get update
sudo apt-get install docker-ce

# dockerグループへユーザを追加
sudo gpasswd -a [ユーザ名] docker

# グループの追加ができたことを確認
id [ユーザ名]

# dockerホストの登録
echo "export DOCKER_HOST=localhost:2375" >> ~/.bash_profile

# Dockerサービス起動
sudo cgroupfs-mount && sudo service docker start

# 一回ログアウトして再ログインする(Windowsも再起動する)
exit

# kuberctlインストール
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - 
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update && apt-get install -y kubelet kubeadm kubectl kubernetes-cni


# クラスタの確認
kubectl config get-clusters

# コンテキストの確認
kubectl config get-contexts

# コンテキストの向き先確認
kubectl config current-context

# namespace作成
kubectl create namespace php-720-sample

# namespace確認
kubectl get namespace

# namespace切り替え
kubectl config current-context
# 上記コマンドで表示されたコンテキスト名を、以下のコマンドset-contextの次に組み込む。
# namespaceには、切り替えたいnamespaceを設定する。
kubectl config set-context docker-for-desktop --namespace=php-720-sample

# コンテキストの向き先確認
kubectl config get-contexts

＜DB構築＞
https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/
https://systemkd.blogspot.com/2018/02/docker-for-mac-kubernetes-ec-cube_12.html

# PersistentVolumeClaimの構築
cd /mnt/c/k8s/php-720-sample/1.db-disk
kubectl apply -f 1.PersistentVolume.yaml

kubectl apply -f 2.PersistentVolumeClaim.yaml

# PersistentVolumeが作成されているかを確認
kubectl get pv

# PersistentVolumeClaimが作成されているかを確認
kubectl get pvc

# secretの作成
# echo -n "database_user" | base64
# echo -n "database_password" | base64
# echo -n "secret_key_base" | base64
kubectl apply -f 3.php-apache-psql-secret.yaml

# pod一覧
kubectl get pod

# init-data.shの実行
# kubectl exec -it postgresql-0 init-data.sh

＜src-deployのpvc構築＞
cd /mnt/c/k8s/php-720-sample/2.src-deploy-disk

# PersistentVolumeの構築
kubectl apply -f 1.PersistentVolume.yaml

# PersistentVolumeClaimの構築
kubectl apply -f 2.PersistentVolumeClaim.yaml

# PersistentVolumeが作成されているかを確認
kubectl get pv
 または
kubectl -n php-720-sample get pv

# PersistentVolumeClaimが作成されているかを確認
kubectl get pvc
 または
kubectl -n php-720-sample get pvc

# 全イメージを表示する．
docker images


＜php-srcのボリュームへチェックアウト＞
# /mnt/c/k8s/php-720-sample/2.src-deploy-disk\storage
# ※ ここで各プロジェクトのソースコードをチェックアウトする

＜postgreSQL構築＞
# postgreSQLイメージビルド
cd /mnt/c/k8s/php-720-sample/3.db-rebuild
./skaffold_run.sh

＜php構築＞
# phpイメージビルド
cd /mnt/c/k8s/php-720-sample/4.php-rebuild
./skaffold_run.sh

＜apache構築＞
# apacheイメージビルド
cd /mnt/c/k8s/php-720-sample/5.apache-rebuild
./skaffold_run.sh

＜mailsv構築＞
# mailsvイメージビルド
cd /mnt/c/k8s/php-720-sample/6.mailsv-rebuild
kubectl apply -f ./k8s-mailsv-sv.yaml

＜ingressを構築＞
# Ingress Controllerの作成
# 参考サイト：https://kubernetes.github.io/ingress-nginx/deploy/
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml
cd /mnt/c/k8s/php-720-sample/7.ingress

# sslの鍵登録 ※HTTPSを使用する際は実施
# kubectl create secret tls d-a.co.jp --key ../5.apache-rebuild/ssl/example1.co.jp/svrkey-sample-empty.key --cert ../5.apache-rebuild/ssl/example1.co.jp/svrkey-sample-empty.crt

# Ingressの作成
kubectl apply -f 80.ingress.yaml

# ingressに割り振られたグローバルアドレスの確認
kubectl get ingress










# namespace切り替え
kubectl config current-context
# 上記コマンドで表示されたコンテキスト名を、以下のコマンドに組み込む
kubectl config set-context docker-for-desktop --namespace=php-720-sample

# コンテキストの向き先確認
kubectl config get-contexts

# pod一覧
kubectl get pod

# init-data.shの実行
kubectl exec -it [podの名称] /bin/bash

# ポートフォワード（postgreSQLへの接続時等に使用）
kubectl port-forward postgresql-0 5432:5432

# kubectl proxyを実行（ダッシュボード閲覧に必要）
kubectl proxy

# ダッシュボードへアクセス
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

# 権限取得
kubectl -n kube-system get secret

# 認証トークン取得（取得したTokenをサインイン画面のトークンで設定してサインインする方式）
kubectl -n kube-system describe secret default

# 認証トークン設定（取得したTokenからkubeconfigを出力し、そのファイルを指定してサインインする方式。）
# 以下のコマンドの[TOKEN]へ取得した認証トークンを設定する。
# kubectl config set-credentials docker-for-desktop --token="[TOKEN]"

# ダッシュボードのサインインの画面で、C:\Users\da-hatakeyama\.kube\configを指定するとサインイン出来る。
