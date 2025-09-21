# 🚀 Terraform AWS VPC with ALB & ASG  

This project demonstrates how to deploy a **scalable, highly available web application** on **AWS** using **Terraform**.  
It provisions a custom **VPC**, public & private subnets, an **Application Load Balancer (ALB)**, and an **Auto Scaling Group (ASG)** of EC2 instances running **Apache**.  

---

## 🌐 Project Overview  

### What This Project Does  
This project automates the creation of a secure and production-ready web environment on AWS:  

- **Custom VPC** – Dedicated network for isolation.  
- **Public Subnets** – Host the ALB and internet-facing resources.  
- **Private Subnets** – Host EC2 instances (web servers) protected from direct internet access.  
- **Application Load Balancer (ALB)** – Distributes traffic across EC2 instances.  
- **Auto Scaling Group (ASG)** – Scales EC2 instances automatically based on demand.  
- **EC2 Instances** – Run Apache web server with a simple webpage.  
- **Security Groups** – Control inbound/outbound traffic securely.  

---

## 🎯 Why This Project is Useful  

- **Automation** – Eliminates manual setup using Infrastructure as Code (IaC).  
- **Scalability** – Auto-scaling handles variable workloads automatically.  
- **High Availability** – Multi-AZ setup ensures fault tolerance.  
- **Security** – Private subnets + NAT Gateway ensure instances are not directly exposed.  

---

## ⚙️ Prerequisites  

Before running the project, ensure you have:  

- **Terraform CLI** (latest version)  
- **AWS Account** with proper IAM access  
- **AWS CLI** configured with credentials  
- **S3 Bucket** (for Terraform remote state)  
- **AMI ID** (update in `ec2.tf` if using a region other than `us-east-1`)  

---

## 🧩 Code Structure  

