## Infrastructure as Code ##  

This project demonstrates how to deploy a **scalable, highly available web application** on **AWS** using **Terraform**.  
It provisions a custom **VPC**, public & private subnets, an **Application Load Balancer (ALB)**, and an **Auto Scaling Group (ASG)** of EC2 instances running **Apache**.  

---

## Project Overview  

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

## Why This Project is Useful  

- **Automation** – Eliminates manual setup using Infrastructure as Code (IaC).  
- **Scalability** – Auto-scaling handles variable workloads automatically.  
- **High Availability** – Multi-AZ setup ensures fault tolerance.  
- **Security** – Private subnets + NAT Gateway ensure instances are not directly exposed.  

---

## Prerequisites ##  

Before running the project, ensure you have:  

- **Terraform CLI** (latest version)  
- **AWS Account** with proper IAM access  
- **AWS CLI** configured with credentials  
- **S3 Bucket** (for Terraform remote state)  
- **AMI ID** (update in `ec2.tf` if using a region other than `us-east-1`)  

---

## 🧩 Code Structure  

├── vpc.tf # VPC, Subnets, Route Tables, IGW, NAT Gateway
├── ec2.tf # ALB, Target Groups, ASG, Security Groups, EC2 Launch Template
├── userdata.sh # Bootstraps EC2 instances with Apache web server



### Key Highlights  

- **vpc.tf** → Defines VPC, Subnets, IGW, NAT, Route Tables.  
- **ec2.tf** → Defines ALB, Target Group, Listener, Launch Template, Auto Scaling Group.  
- **userdata.sh** → Installs Apache, starts service, and serves a simple webpage.  

---

## Deployment Steps  

1. **Clone the Repository**  
   ```bash
   git clone https://github.com/yourusername/aws-vpc-alb-asg.git
   cd aws-vpc-alb-asg

2. **Initialize Terraform**
     terraform init

3. **Review the Plan**
    terraform plan

4. **Apply Configuration**
    terraform apply
   
5. **Apply Configuration**
    terraform output aws_dns_name


**Final Output**

A highly available web application accessible via the ALB DNS.

**Example output**:
aws_dns_name = "**my-aws-lb-123456789.us-east-1.elb.amazonaws.com**"
Open this DNS in a browser → You’ll see an Apache welcome page.
Refreshing shows responses from different EC2 instances (via ALB load balancing).   



**Technologies Used**

Terraform – Infrastructure as Code
AWS VPC, Subnets, IGW, NAT Gateway – Networking
AWS ALB – Load Balancing
AWS Auto Scaling Group – Elastic scaling
EC2 + Apache – Web server

**Outcome**
You now have a scalable, secure, fault-tolerant infrastructure on AWS — all built automatically using Terraform.











