# QuantumRift Project 

**I've been struggling with this task for the past 15 hours.** The primary reason is that I haven't had the opportunity to work on quick and dirty systems in my previous roles. I've primarily dealt with large and complex architectures, which I believe has hindered my ability to achieve the compact structure required for this assignment.

**Initially, I attempted to create everything using Terraform.** I'd like to elaborate on the "everything" part. I overengineered in many areas in my pursuit of maximizing cloud infrastructure utilization. I delved into creating buckets, service accounts, setting up automatic GitLab installation and utilization. etc.. 

**Subsequently, I faced significant challenges with web3.js.** Unfortunately, I couldn't find a straightforward example on the internet that utilized this library and could be integrated into my pipeline. I spent two hours searching relentlessly. I discovered a few workable solutions, but most were multi-docker container applications that either created an Ethereum contract server locally or performed automated smart contract tasks. Understanding these applications and implementing them into the pipeline took three times longer than the total time allotted for this project in the documentation.

**Finally,** this task came to me when we have one of the biggest national holiday. I have to spend time with people for this special occasion. you can call it, turkish christmas. So i lost time and before i sent you this, i want to be sure that everything **ACTUALLY** working which consume all the extra hours i poured in this project. 


Anyway Let's Go.

1. I have created infra from scratch with terraform. main.tf can create VPC, subnet, virtual machine, service account for gke, gke cluster. It also install gitlab to vm so we can use it for future purposes. unfortunately gitlab process wont be automatically work. so you need to configure some stuff in it. I have spent 2 hours to try to make it automatically configure itself but at some point you cant do it without ssh the gitlab server to execute some commands. Also runner part needs lots of attention. Before all this works you need to `gcloud auth login` with your terminal and also you need to `gcloud config set project <projectid>` to apply terraform script to targeted environment. 

File: main.tf 
2. I have tried to explain on introduction as well that i had some problems with web3.js part and i kinda accept the defeat. I choose to use some simple node.js app for build and execute with docker. 

File: Dockerfile 


3. I have created one deployment object, under k8s folder. test it my local minikube. 


4. The pipeline is integrated with GKE. A service account was created using Terraform. This account has access to Google Artifact Registry and GKE management rights.
File: .gitlab-ci.yml
Steps:

    Install dependencies
    Build the container using the Dockerfile in the k8s folder and push it to GAR
    Use the official GCP container with gcloud cli to authenticate with the service account and deploy the container to K8s
    Deploy the app to the created cluster

Additional notes:

    The deployment is performed using Gitlab runner located inside the K8s cluster.
	The use of a service account ensures that the deployment process has the necessary permissions to access Google Artifact Registry and manage GKE resources.
    The pipeline utilizes the official GCP container with gcloud cli to authenticate with the service account and perform the deployment.
    The integration of Gitlab runner within the K8s cluster facilitates the execution of the deployment process from within the cluster environment.


PS: I really enjoyed all the process of finishing this assignment because i am managing an infrastructure i have already created months ago and there is not lots of new technical challenge happening around. Thanks for this chance to create new architecture for scratch. 
