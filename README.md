

change the project 

gcloud config set project $MY_PROJECT_ID

# Process 
## Task1
- change the project for gcloud to configure QR env 
`gcloud config set project $MY_PROJECT_ID`
- Created a GCP project
- Enable compute service, GKE service 
- created a Service Account for terraform 

`gcloud iam service-accounts create qr-tf-sa --display-name=???QR_Terraform_SA???`






Analiz
- terraform ile network, subnet, vm yarat
- gcloud cli ile servis acc'leri yarat
	- artifact registry
	- kubernetes deployment 
	- compute

- gitlab'i vm'in icine kur
script ile kurduktan sonra vm'e bağlanıp 
sudo cat /etc/gitlab/initial_root_password yada sudo gitlab-rake "gitlab:password:reset[root]"  ile şifreyi resetliyoruz. 
sonrasında http://34.141.23.142/users/sign_in adresinden girebiliyoruz. 





- web3.js aplikasyonunu incele
	web3.js app bulamadım doğru düzgün. docker'ın bir tane simple node.js örneğini buldum. onun üzerinden gittim. 
	şuan bu çalışıyor. 
	docker build . -t node_test(buraya normalde bütün container registry adresi basmamız lazım ki bu repoyu pushlayalım) 


- web3.js aplikasyonunun calisabilecegi bir dockerfile yarat tamam 
- yaratilan dockerfile'i lokalde test et tamam


- console'dan  gke cluster yarat



- web3.js'yi calistiran bir k8s deployment ve k8s service dosyasi yarat



- gitlab'da web.js aplikasyonunu build edebilen bir pipeline yaz.
	- dockerfile'i pipeline'a ekle
	- google artifact repository'i pipeline'a ekle 
	- kubernetes deployment'i pipeline'a ekle.
	- servis hesaplarini degisken olarak pipeline ekle

sudo gitlab-ctl reconfigure
