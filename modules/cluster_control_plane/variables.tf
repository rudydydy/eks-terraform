variable cluster_name {
  description = "EKS cluster name"
  type        = string
}

variable k8s_version {
  description = "kubernetes version"
  type        = string
}

variable subnet_ids {
  description = "VPC subnet ids"
  type        = list
}
