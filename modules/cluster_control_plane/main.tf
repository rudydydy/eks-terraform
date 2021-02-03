################################################################################
# IAM Role for EKS Cluster 
# - assign policy 'AmazonEKSClusterPolicy' and 'AmazonEKSServicePolicy'
################################################################################
resource "aws_iam_role" "control_plane" {
  name = "${var.cluster_name}-control-plan-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.control_plane.name
}

resource "aws_iam_role_policy_attachment" "service" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.control_plane.name
}

################################################################################
# Cluster control plane
################################################################################
resource "aws_eks_cluster" "main" {
  name            = var.cluster_name
  version         = var.k8s_version
  role_arn        = aws_iam_role.control_plane.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster,
    aws_iam_role_policy_attachment.service,
  ]
}
