#########################################################################  Why this project? ##############################################################################
In the real world, applications need to be:
Highly available → using multiple subnets/AZs, ALB, and Auto Scaling ensures uptime.
Secure → instances stay in private subnets, hidden from the internet, only accessible via ALB.
Scalable → Auto Scaling Group automatically adjusts instance count based on demand.
Automated & Repeatable → Terraform codifies the entire infrastructure, so it can be deployed, updated, or destroyed consistently in minutes.
This project is a practical demonstration of building a production-ready, cloud-native architecture. It helps learners and professionals understand how modern web applications are deployed on AWS using Infrastructure as Code (IaC).


########  Project Overview

This project uses Terraform to automate the creation of a complete highly available web application infrastructure on AWS.
A VPC is set up with both public and private subnets across multiple availability zones.
A public-facing Application Load Balancer (ALB) distributes traffic to an Auto Scaling Group (ASG) of EC2 instances running inside the private subnets (so they are not exposed directly to the internet).
A NAT Gateway is provided in the public subnet to allow private instances to download updates/packages securely without needing public IPs.
Security Groups ensure controlled access: the ALB accepts HTTP traffic from the internet, and EC2 instances only accept traffic coming from the ALB.
Terraform’s S3 backend stores the remote state, making it easier for teams to collaborate.
