resource "aws_eks_cluster" "gok" {
  name     = "gok-cluster"
  role_arn = "arn:aws:iam::682033461247:role/eksctl-sabo1-cluster-ServiceRole-NNclcnqbWIvL"
  vpc_config {
    subnet_ids         = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
    security_group_ids = [aws_security_group.eks.id]
  }
}

resource "aws_eks_node_group" "gok" {
  cluster_name = aws_eks_cluster.gok.name
  subnet_ids   = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 1
  }
  instance_types = ["t3.medium"]
  node_role_arn  = "arn:aws:iam::682033461247:role/eksctl-sabo1-cluster-ServiceRole-NNclcnqbWIvL"
  labels = {
    "app" = "gok"
  }
  tags = {
    "Name"        = "gok-worker-node"
    "Environment" = "production"
    "Project"     = "gok-app"
  }
}