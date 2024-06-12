# quantumRift

1. GCP'de 1 vm'in olduğu basit bir proje yarat
2. web3.js çalıştıran bir dockerfile yarat
3. k8s deployment dosyası yaz bu web3.js için
4. gitlab ile bir pipeline yarat. bu web3.js kodunu build edip k8s cluster'a deploy etsin
5. süreçlerin dökümanını markdown ile çıkar.



change the project 

gcloud config set project $MY_PROJECT_ID

# Process 
## Task1
- change the project for gcloud to configure QR env 
`gcloud config set project $MY_PROJECT_ID`
- Created a GCP project
- Enable compute service, GKE service 
- created a Service Account for terraform 

`gcloud iam service-accounts create qr-tf-sa --display-name=”QR_Terraform_SA”`

- 




