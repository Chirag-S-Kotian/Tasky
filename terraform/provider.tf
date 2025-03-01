terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.89.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.25.2"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

provider "kubernetes" {
  host                   = aws_eks_cluster.gok.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.gok.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.gok.token
}

data "aws_eks_cluster_auth" "gok" {
  name = aws_eks_cluster.gok.name
}