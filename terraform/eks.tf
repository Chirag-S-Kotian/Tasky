resource "aws_iam_role" "eks" {
  name = "gok-eks-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "gok" {
  name     = "gok-cluster"
  role_arn = aws_iam_role.eks.arn
  vpc_config {
    subnet_ids         = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
    security_group_ids = [aws_security_group.eks.id]
  }
  depends_on = [aws_iam_role_policy_attachment.eks_policy]
}

resource "aws_iam_role" "nodes" {
  name = "gok-nodes-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "nodes_policy" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "nodes_cni" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSCNIPolicy"
}

resource "aws_eks_node_group" "gok" {
  cluster_name    = aws_eks_cluster.gok.name
  node_group_name = "gok-nodes"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }
  instance_types = ["t3.medium"]
  depends_on     = [
    aws_iam_role_policy_attachment.nodes_policy,
    aws_iam_role_policy_attachment.nodes_cni
  ]
}