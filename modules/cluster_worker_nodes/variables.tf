variable cluster_name {
  description = "EKS cluster name"
  type        = string
}

variable k8s_version {
  description = "kubernetes version"
  type        = string
}

variable public_subnet_ids {
  description = "VPC public subnet ids"
  type        = list
}

variable private_subnet_ids {
  description = "VPC private subnet ids"
  type        = list
}

variable worker_nodes {
  description = "Map of worker nodes manage by cluster"
  type        = map
}

