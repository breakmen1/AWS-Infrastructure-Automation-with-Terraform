This documentation provides a comprehensive, step-by-step guide to deploying a scalable, highly available web application on AWS using Terraform. The project creates a custom Virtual Private Cloud (VPC) with public and private subnets, an Application Load Balancer (ALB), and an Auto Scaling Group (ASG) for EC2 instances. The web servers run Apache and are automatically deployed and managed.

Project Overview 💻
🌐 What the Project Does
This project automates the creation of a secure and scalable web application environment on Amazon Web Services (AWS) using Terraform. It establishes a multi-tier architecture to ensure high availability and fault tolerance. The infrastructure includes:

Custom VPC: A dedicated virtual network to isolate resources.

Public Subnets: Where the load balancer and other internet-facing resources reside. Traffic is routed to the internet via an Internet Gateway.

Private Subnets: Where the web servers (EC2 instances) are deployed, protected from direct internet access. They can still access the internet for updates via a NAT Gateway.

Application Load Balancer (ALB): Distributes incoming web traffic to the EC2 instances. It resides in the public subnets.

Auto Scaling Group (ASG): Automatically adjusts the number of EC2 instances based on demand, ensuring performance and fault tolerance.

EC2 Instances: The web servers running Apache. They are launched from a specific AMI and configured with a simple web page.

Security Groups: Act as virtual firewalls to control inbound and outbound traffic to the ALB and EC2 instances.

🎯 Why This Project is Useful
The primary goal of this project is to showcase how to build a robust, production-ready environment using Infrastructure as Code (IaC). Key benefits include:

Automation: Eliminates manual configuration, reducing human error and saving time.

Scalability: The Auto Scaling Group ensures the application can handle varying loads without manual intervention.

High Availability: The use of multiple Availability Zones (AZs) ensures that if one AZ fails, the application remains operational.

Security: The multi-tier design isolates private resources, enhancing security by preventing direct public access to the web servers.

Prerequisites and Setup ⚙️
Before you begin, ensure you have the following tools and access configured:

Terraform CLI: The latest version of Terraform must be installed on your machine.

AWS Account: You need an active AWS account.

AWS CLI: The AWS Command Line Interface should be configured with your AWS credentials. This allows Terraform to authenticate and create resources in your account.

S3 Bucket: The Terraform configuration uses a remote backend to store the state file. You'll need to create an S3 bucket in your AWS account and replace "mys300259ede69013c771e40" with your bucket's name in the vpc.tf file.

AMI ID: The ami-0bbdd8c17ed981ef9 in the code is specific to the us-east-1 region. If you are using a different region, you must find a valid AMI ID for that region.

Code Breakdown and Resource Explanation 🧩
The project is split into two Terraform configuration files: vpc.tf for network resources and ec2.tf for compute resources. The userdata.sh script is used to configure the EC2 instances.

vpc.tf
This file defines the foundational network infrastructure.

terraform block: Specifies the required AWS provider and configures the S3 remote backend. The backend stores the state file (.tfstate), which tracks the deployed resources, in an S3 bucket.

aws_vpc.my-aws-vpc: Creates a Virtual Private Cloud (VPC) with a CIDR block of 10.0.0.0/16. This provides a private, isolated network for all resources.

variable "aws_availability_zones": Defines a list of Availability Zones to be used for subnets, ensuring high availability.

aws_subnet.my-public-subnet: Creates two public subnets in different AZs. The cidrsubnet function dynamically calculates a /24 CIDR block for each subnet (e.g., 10.0.1.0/24, 10.0.2.0/24).

aws_subnet.my-private-subnet: Creates two private subnets, also in different AZs, with their own dynamically calculated CIDR blocks (e.g., 10.0.3.0/24, 10.0.4.0/24).

aws_internet_gateway.my-aws-igw: Attaches an Internet Gateway (IGW) to the VPC, enabling public subnets to communicate with the internet.

aws_route_table.my-aws-rt: Creates a public route table that directs all (0.0.0.0/0) outbound traffic to the IGW.

aws_route_table_association.my-aws-pub-rta: Associates the public route table with the public subnets.

aws_eip.my-pub-elastic-ip: Allocates a static public IP address for the NAT Gateway.

aws_nat_gateway.my-aws-nat: Deploys a NAT Gateway in the first public subnet. This allows resources in the private subnets to initiate outbound connections to the internet (e.g., for updates) without receiving unsolicited inbound traffic.

aws_route_table.my-aws-pri-rt: Creates a private route table that routes all (0.0.0.0/0) outbound traffic through the NAT Gateway.

aws_route_table_association.my-aws-pri-rta: Associates the private route table with the private subnets.

ec2.tf
This file handles the compute layer, including the load balancer and auto-scaling.

aws_security_group.aws-secu-alb: Defines a security group for the ALB. It allows inbound traffic on port 80 (HTTP) from anywhere (0.0.0.0/0).

aws_security_group.aws-secu-ec2: Defines a security group for the EC2 instances. It only allows inbound traffic from the ALB's security group, ensuring that the web servers are not directly accessible from the internet.

aws_lb.my-aws-lb: Creates an Application Load Balancer (ALB) in the public subnets. It's configured to be public-facing (internal = false).

aws_lb_target_group.my-aws-lb-tar: Creates a Target Group for the ALB. It listens on port 80 and is associated with the VPC. The EC2 instances will register with this target group.

aws_lb_listener.my-aws-lb-list: Creates a listener for the ALB on port 80 (HTTP). It forwards all traffic to the target group.

aws_launch_template.ec2-launch-template: A template for launching new EC2 instances. It specifies the AMI ID, instance type (t2.micro), and associates the private security group. The user_data field references the userdata.sh file, which contains the startup script.

aws_autoscaling_group.my-aws-auto-scal: An Auto Scaling Group (ASG) that ensures a minimum of 2 and a maximum of 3 EC2 instances are running. It's configured to launch instances into the private subnets and register them with the ALB target group.

output "aws_dns_name": An output variable that displays the DNS name of the created ALB, which is the public endpoint for the web application.

userdata.sh
This is a shell script that runs on the EC2 instances at boot time.

apt update -y: Updates the package lists.

apt install -y apache2: Installs the Apache web server.

systemctl start apache2: Starts the Apache service.

systemctl enable apache2: Ensures Apache starts automatically on future reboots.

echo ... > /var/www/html/index.html: Creates a simple HTML file to serve as the web page. The message includes the private IP address of the instance, confirming which server is serving the request.

Execution and Final Output 🚀
➡️ Step-by-Step Execution
Clone the Repository: Place the vpc.tf, ec2.tf, and userdata.sh files in the same directory.

Initialize Terraform: Open your terminal in the project directory and run terraform init. This command downloads the necessary AWS provider and initializes the S3 backend.

Review the Plan: Run terraform plan. This will show you a detailed list of all the resources Terraform will create, change, or destroy.

Apply the Configuration: If the plan looks correct, run terraform apply. Type yes when prompted to confirm the execution.

Wait for Completion: Terraform will now provision all the resources in your AWS account. This process can take several minutes.

Retrieve the Output: Once terraform apply is complete, the output "aws_dns_name" will display the public DNS name of the ALB.

🌐 Final Output
The final output of the project is a functional, highly available web application. You can access it by opening a web browser and navigating to the DNS name provided by the Terraform output.

When you refresh the page, the content will change to show the private IP address of a different EC2 instance, demonstrating that the ALB is successfully distributing traffic across the two web servers.

The final DNS output will look similar to this:

aws_dns_name = "my-aws-lb-123456789.us-east-1.elb.amazonaws.com"
