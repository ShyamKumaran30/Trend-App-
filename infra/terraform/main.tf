

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#########################################################
# VPC Module
#########################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "trend-vpc-1"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a","us-east-1b"]
  public_subnets  = ["10.0.1.0/24","10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24","10.0.12.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
}

#########################################################
# EC2 Key Pair for Jenkins
#########################################################
#resource "aws_key_pair" "jenkins_key" {
# key_name   = "jenkins-keypair"
# public_key = file("C:/Users/shyam/Jenkins.pub")  # Use public key
#}

#########################################################
# Security Group for Jenkins EC2
#########################################################
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH and Jenkins"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#########################################################
# EC2 Instance for Jenkins
#########################################################
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  key_name               = "jenkins-keypair"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "jenkins-server"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y openjdk-11-jre docker.io git
              systemctl start docker
              systemctl enable docker
              wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
              sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
              apt-get update -y
              apt-get install -y jenkins
              systemctl enable jenkins
              systemctl start jenkins
              usermod -aG docker ubuntu
              EOF
}

#########################################################
# EKS Cluster with Managed Node Group
#########################################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "trend-eks-cluster-1"
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  eks_managed_node_groups = {
    trend_nodes = {
      desired_capacity = 2
      min_capacity     = 1
      max_capacity     = 3
      instance_type    = "t3.medium"
      key_name         = "jenkins-keypair"
    }
  }
  
  tags = {
    Environment = "dev"
    Project     = "Trend-App"
  }
}


module "eks_aws_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  depends_on = [module.eks]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::866945988845:user/eks-admin-temp"
      username = "eks-admin-temp"
      groups   = ["system:masters"]
    }
  ]
}
