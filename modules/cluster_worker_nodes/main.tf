################################################################################
# IAM Role for EKS Worker nodes 
# - assign policy 'AmazonEKSWorkerNodePolicy', 'AmazonEKS_CNI_Policy', and 'AmazonEC2ContainerRegistryReadOnly'
################################################################################
resource "aws_iam_role" "worker_node" {
  name = "${var.cluster_name}-worker-nodes-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "worker" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker_node.name
}

resource "aws_iam_role_policy_attachment" "cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker_node.name
}

resource "aws_iam_role_policy_attachment" "registry" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker_node.name
}

################################################################################
# Cluster worker nodes
################################################################################
locals {
  worker_subnet_ids = {
    public  = var.public_subnet_ids
    private = var.private_subnet_ids
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name
  version         = var.k8s_version
  node_role_arn   = aws_iam_role.worker_node.arn

  for_each             = var.worker_nodes
  node_group_name      = each.key
  subnet_ids           = lookup(local.worker_subnet_ids, each.value.subnet_type)
  instance_types       = each.value.instance_types
  capacity_type        = each.value.capacity_type
  disk_size            = each.value.disk_size
  force_update_version = each.value.force_update_version
  labels               = each.value.kubernetes_labels
  tags                 = each.value.tags

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker,
    aws_iam_role_policy_attachment.cni,
    aws_iam_role_policy_attachment.registry,
  ]
}
