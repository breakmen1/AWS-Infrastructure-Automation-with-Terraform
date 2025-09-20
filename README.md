AWS Terraform: VPC + ALB + AutoScaling (Public + Private subnets) — README

Short summary: This repo builds a 2-AZ VPC with public and private subnets, an Internet Gateway, a NAT Gateway, an Application Load Balancer (ALB) in the public subnets, an AutoScaling Group (ASG) launching instances into the private subnets (using a Launch Template), and the security groups & route tables required. The ALB serves traffic (HTTP/80) to the ASG. The terraform S3 backend stores the state remotely.

This README walks you through why each piece exists, what it does, and exact, copy-paste steps anyone can follow to create the same infra in their own AWS account. It also lists common pitfalls and quick fixes.

Architecture (high level)
Internet
   |
 [ALB]  <-- public subnets (us-east-1a, us-east-1b)  (SG: allow 80 from 0.0.0.0/0)
   |
Target group -> AutoScaling Group (instances in private subnets, no public IP)
                  (SG: allow all from ALB SG)
Private subnets (us-east-1a, us-east-1b)
   |
Routes to NAT Gateway (in public subnet) -> Internet via IGW


ALB lives in public subnets and accepts user traffic.

Instances live in private subnets (no public IP); they reach the internet via NAT (for updates, package installs).

AutoScalingGroup registers instances into target group automatically.

State is persisted in an S3 backend (so multiple team members can collaborate).

Files in this repo (what I expect to see)

vpc.tf — VPC, subnets, IGW, NAT, route tables, backend & provider block

ec2.tf — security groups, ALB, target group, listener, launch template, autoscaling group, outputs

userdata.sh — bootstrap script run on each instance (installs web server & a simple page)

README.md — this file (you’re reading it)

(optional) variables.tf, outputs.tf — if you split variables/outputs

.gitignore — ignore .terraform/, terraform.tfstate, etc.

If you don’t have separate files already, the two files you posted (vpc.tf and ec2.tf) + userdata.sh are enough to run the example after the small fixes listed below.

Prerequisites

AWS account with permissions to create VPCs, Subnets, IGW, Route Tables, NAT Gateways, EIPs, Security Groups, EC2, ALB (Elastic Load Balancing v2), Target Groups, Launch Templates, AutoScaling, IAM (if you add instance profiles), S3 (for state), optionally DynamoDB (for state locking).

Terraform installed (I built/test with Terraform 1.x). The provider in the code is hashicorp/aws 6.13.0 — use a similar version.

AWS CLI (optional but useful) and configured credentials / profile, OR export AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY / AWS_DEFAULT_REGION.

An S3 bucket to use as a Terraform backend (existing). Optionally a DynamoDB table for state locking (recommended for teams).

(Optional) An SSH key pair in the region if you want SSH access to instances (or use SSM with an instance profile).
