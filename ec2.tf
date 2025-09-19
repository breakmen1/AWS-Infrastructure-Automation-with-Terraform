resource "aws_security_group" "aws-secu-alb" {
  vpc_id = aws_vpc.my-aws-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MY_SEC_ALB"
  }
}


resource "aws_security_group" "aws-secu-ec2" {
  vpc_id = aws_vpc.my-aws-vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.aws-secu-alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MY_SEC_EC2"
  }
}

resource "aws_lb" "my-aws-lb" {
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.aws-secu-alb.id]
  subnets            = aws_subnet.my-public-subnet[*].id
  depends_on         = [aws_internet_gateway.my-aws-igw]
}

resource "aws_lb_target_group" "my-aws-lb-tar" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-aws-vpc.id

  tags = { 
    Name = "MY_LB_TARGET"
  }
}

resource "aws_lb_listener" "my-aws-lb-list" {
  load_balancer_arn = aws_lb.my-aws-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-aws-lb-tar.arn
  }

  tags = {
    Name = "MY_LB_LISTNER"
  }
}


resource "aws_launch_template" "ec2-launch-template" {

  image_id      = "ami-0bbdd8c17ed981ef9"
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.aws-secu-ec2.id]
  }

  user_data = filebase64("userdata.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "MY_EC2_LAUNCH_TEMPLATE"
    }

  }

}

resource "aws_autoscaling_group" "my-aws-auto-scal" {
  desired_capacity    = 2
  min_size            = 2
  max_size            = 3
  target_group_arns   = [aws_lb_target_group.my-aws-lb-tar.arn]
  vpc_zone_identifier = aws_subnet.my-private-subnet[*].id

  launch_template {
    id      = aws_launch_template.ec2-launch-template.id
    version = "$Latest"
  }

  health_check_type = "EC2"
}

output "aws_dns_name" {
  value = aws_lb.my-aws-lb.dns_name
}