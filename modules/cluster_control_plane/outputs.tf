output endpoint {
  value = aws_eks_cluster.main.endpoint
}

output certificate_authority_data {
  value = aws_eks_cluster.main.certificate_authority[0].data
}
