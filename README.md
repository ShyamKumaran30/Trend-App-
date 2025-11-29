# 🚀 Trend App – End-to-End Deployment on AWS  
## Docker • Terraform • AWS EKS • Jenkins CI/CD • DockerHub • Monitoring

This project demonstrates the complete automation and deployment of the **Trend App**, a static HTML application, into a fully managed Kubernetes environment on **AWS EKS**, using **Terraform**, **Docker**, and a **Jenkins CI/CD pipeline**.

---

## 📌 Project Overview

The deployment includes:

- Containerization using **Docker**
- Image hosting on **DockerHub**
- **Terraform** infrastructure provisioning:
  - VPC, Subnets, Route Tables, IGW
  - EC2 for Jenkins
  - EKS Cluster + Node Group
- **Jenkins CI/CD pipeline** to automate:
  - Code checkout
  - Docker build & push
  - Deployment to EKS
- **Kubernetes** Deployment + LoadBalancer Service
- **Monitoring** using Kubernetes Metrics Server

---

## 1️⃣ Application

A simple static HTML application served via **NGINX**.

---

## 2️⃣ Docker Setup

- Build Docker image  
- Test locally  
- Push image to DockerHub  

(All commands showcased in documentation/screenshots)

---

## 3️⃣ Terraform Infrastructure

Terraform provisions:

- Networking (VPC, Subnets, NAT, IGW)  
- EC2 instance for Jenkins  
- EKS Cluster  
- Managed Node Group  

Outputs include:

- EKS Endpoint  
- EKS CA Certificate  
- Jenkins Public IP  
- LoadBalancer ARN  

---

## 4️⃣ Jenkins Setup

Jenkins is run using Docker and configured with required plugins:

- Pipeline  
- Docker Pipeline  
- GitHub  
- Kubernetes CLI  

Credentials stored in Jenkins:

- DockerHub Username  
- DockerHub Password/Token  

---

## 5️⃣ CI/CD Pipeline

The Jenkins pipeline performs:

1. Clone the GitHub repository  
2. Build Docker image  
3. Authenticate to DockerHub  
4. Push the container image  
5. Deploy to Kubernetes using `kubectl`  

---

## 6️⃣ Kubernetes Deployment

The application is deployed on AWS EKS using:

- Deployment (Replica: 2)
- LoadBalancer Service (public endpoint)

After deployment, access the app using the LoadBalancer DNS Name.

---

## 7️⃣ Accessing the Application

LoadBalancer URL:

- http://a7b1ab25aa10441ea95e66447bf2d36a-2018567849.us-east-1.elb.amazonaws.com/
---

## 8️⃣ Monitoring

Metrics Server is installed to monitor:

- **Node resource usage**
- **Pod resource usage**

Command used:
- `k9s`

---

## 9️⃣ Screenshots

### Terraform
- VPC, Subnets  
- Jenkins EC2  
- EKS Cluster  
- Node Group  

### Jenkins
- Dashboard  
- Installed Plugins  
- Successful Pipeline Output  

### Docker
- Built Image  
- Push to DockerHub  

### Kubernetes
- Nodes  
- Pods  
- Services (LoadBalancer)  
- Application running in browser  

### Monitoring
- Node metrics  
- Pod metrics  

All the images are added in the docs file.
