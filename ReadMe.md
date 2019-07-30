__**************************************************************************************__  
__*　Docker for Windows におけるLAPP環境構築__  
__**************************************************************************************__  
  
  
#### この設定ファイルを作成したブログ記事__  
https://www.d-a.co.jp/staff/index.php?itemid=11051  

__**************************************************************************************__  
__*　ファイル構成__  
__**************************************************************************************__  

php-720-sample/  
　┣1.db-disk/・・・DBの永続ボリュームを作成するyaml等  
　┣2.src-deploy-disk/・・・srcの永続ボリュームを作成するyaml等  
　┣3.db-rebuild/・・・DBのコンテナ、service、deployment等を作成するyaml等  
　┣4.php-rebuild/・・・php-fpmのコンテナ、service、deployment等を作成するyaml等  
　┣5.apache-rebuild/・・・apacheのコンテナ、service、deployment等を作成するyaml等  
　┣6.mailsv-rebuild/・・・postfixのコンテナ、service、deployment等を作成するyaml等  
　┣7.ingress/・・・ingressのyaml等  
　┣kube-db-proxy.bat・・・podのDBへDBクライアント（A5等）から接続する為のポートフォワード起動  
　┣kubeproxy.bat・・・kubernetesダッシュボードへアクセスする為のproxyを実行するバッチ  
　┗ReadMe.md・・・使い方等々の説明  

__**************************************************************************************__  
__*　前提条件：この設定ファイルの環境要件__  

【環境要件】  
◆OS  
・Windows10 Pro(x64)  

◆ソフトウェア  
・Docker for Windows  
・Ubuntu 18.04 LTS  

__**************************************************************************************__  
__*　kubernetesを動かす基盤となるソフトウェアのインストール（全てUbuntu 18.04 LTSで実施）__  
__*　※ 1回だけ実施すればよい。__  
__**************************************************************************************__  

#### k8s-php-720-sampleのフォルダの中身を「C:\k8s\php-720-sample」へ配置する。

#### Docker for Windowsをインストールし、設定画面でkubernetesを有効にする。

#### WSLでskaffoldインストール
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64  
chmod +x skaffold  
sudo mv skaffold /usr/local/bin  

#### WSL(Bash on Windows)でDockerを使用する
#####  ＜参考＞
#####  https://qiita.com/yoichiwo7/items/0b2aaa3a8c26ce8e87fe
#####  https://medium.com/@XanderGrzy/developing-for-docker-kubernetes-with-windows-wsl-9d6814759e9f
#####  https://www.myzkstr.com/archives/888

#### Docker for Windowsの設定で、WSLから使えるようにする。
Setting画面からGeneralタブを開き、Expose daemon on tcp://localhost:2375 without TLSにチェックを入れる。

#### 事前パッケージインストール
sudo apt-get install \  
    apt-transport-https  ca-certificates curl \  
    software-properties-common  

#### Docker公式のGPG鍵を追加,確認
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -  
sudo apt-key fingerprint 0EBFCD88  

#### Dockerレポジトリを追加 (Stableチャンネルのレポジトリ)
sudo add-apt-repository \  
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \  
   $(lsb_release -cs) \  
   stable"  

#### Dockerインストール (Communityエディション)
sudo apt-get update  
sudo apt-get install docker-ce  

#### dockerグループへユーザを追加
sudo gpasswd -a [ユーザ名] docker  

#### グループの追加ができたことを確認
id [ユーザ名]  

#### dockerホストの登録
echo "export DOCKER_HOST=localhost:2375" >> ~/.bash_profile  

#### Dockerサービス起動
sudo cgroupfs-mount && sudo service docker start  

#### 一回ログアウトして再ログインする(Windowsも再起動する)
exit  

#### kuberctlインストール
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -   
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list  
sudo apt-get update && apt-get install -y kubelet kubeadm kubectl kubernetes-cni  


__**************************************************************************************__  
__*　kubernetesでLAPP環境構築する手順__  
__*　※ 1回だけ実施すれば良い。__  
__*　kubernetesの環境を作り直したい場合は以下で作成した環境を一度削除し、__  
__*　もう一度実施する事も可能。phpのpodだけ削除して作り直すことも可能だし、__  
__*　skaffoldを使っている箇所は設定を変更してskaffold_run.shを実行するだけで反映される。__  
__**************************************************************************************__  

#### クラスタの確認
kubectl config get-clusters  

#### コンテキストの確認
kubectl config get-contexts  

#### コンテキストの向き先確認
kubectl config current-context  

#### namespace作成
kubectl create namespace php-720-sample  

#### namespace確認
kubectl get namespace  

#### namespace切り替え
kubectl config current-context  
##### 上記コマンドで表示されたコンテキスト名を、以下のコマンドset-contextの次に組み込む。  
##### namespaceには、切り替えたいnamespaceを設定する。  
kubectl config set-context docker-for-desktop --namespace=php-720-sample  

#### コンテキストの向き先確認
kubectl config get-contexts  

#### ＜DBのpvc構築＞
##### ＜参考＞
##### https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/  
##### https://systemkd.blogspot.com/2018/02/docker-for-mac-kubernetes-ec-cube_12.html  

#### PersistentVolumeClaimの構築
cd /mnt/c/k8s/php-720-sample/1.db-disk  
kubectl apply -f 1.PersistentVolume.yaml  
kubectl apply -f 2.PersistentVolumeClaim.yaml  

#### PersistentVolumeが作成されているかを確認
kubectl get pv  

#### PersistentVolumeClaimが作成されているかを確認
kubectl get pvc  

#### secretの作成
##### キーの作成は以下のようにして行う
##### echo -n "database_user" | base64
##### echo -n "database_password" | base64
##### echo -n "secret_key_base" | base64
kubectl apply -f 3.php-apache-psql-secret.yaml  

#### pod一覧
kubectl get pod  

#### ＜src-deployのpvc構築＞
cd /mnt/c/k8s/php-720-sample/2.src-deploy-disk  

#### PersistentVolumeの構築
kubectl apply -f 1.PersistentVolume.yaml  

#### PersistentVolumeClaimの構築
kubectl apply -f 2.PersistentVolumeClaim.yaml  

#### PersistentVolumeが作成されているかを確認
kubectl get pv  
 または  
kubectl -n php-720-sample get pv  

#### PersistentVolumeClaimが作成されているかを確認
kubectl get pvc  
 または  
kubectl -n php-720-sample get pvc  

#### 全イメージを表示する．
docker images  


#### ＜php-srcのボリュームへチェックアウト＞
##### /mnt/c/k8s/php-720-sample/2.src-deploy-disk\storage
##### ※ ここで各プロジェクトのソースコードをチェックアウトする

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
##### kubectl create secret tls d-a.co.jp --key ../5.apache-rebuild/ssl/example1.co.jp/svrkey-sample-empty.key --cert ../5.apache-rebuild/ssl/example1.co.jp/svrkey-sample-empty.crt

#### Ingressの作成
kubectl apply -f 80.ingress.yaml  

#### ingressに割り振られたグローバルアドレスの確認
kubectl get ingress  

__**************************************************************************************__  
__*　以下はkubernetesを操作する際によく使うコマンド__  
__**************************************************************************************__  

#### namespace切り替え
kubectl config current-context  
#### 上記コマンドで表示されたコンテキスト名を、以下のコマンドに組み込む
kubectl config set-context docker-for-desktop --namespace=php-720-sample  

#### コンテキストの向き先確認
kubectl config get-contexts  

#### pod一覧
kubectl get pod  

#### init-data.shの実行
##### init-data.shはpod起動時に自動で実行される。pod稼働中に必要になった場合に以下を実行する。
kubectl exec -it [podの名称] /bin/bash  


#### ポートフォワード（postgreSQLへの接続時等に使用）
kubectl port-forward postgresql-0 5432:5432  

#### kubectl proxyを実行（ダッシュボード閲覧に必要）
kubectl proxy  

#### ダッシュボードへアクセス
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/  

#### 権限取得
kubectl -n kube-system get secret  

#### 認証トークン取得（取得したTokenをサインイン画面のトークンで設定してサインインする方式）
kubectl -n kube-system describe secret default  

#### 認証トークン設定（取得したTokenからkubeconfigを出力し、そのファイルを指定してサインインする方式。）
##### 以下のコマンドの[TOKEN]へ取得した認証トークンを設定する。
##### kubectl config set-credentials docker-for-desktop --token="[TOKEN]"

#### ダッシュボードのサインインの画面で、C:\Users\[ユーザ名]\.kube\configを指定するとサインイン出来る。
