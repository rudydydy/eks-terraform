output project_ecr_url {
  description = "Map of created AWS ECR, outputting project name and repository url"
  value       = {
    for p in keys(var.ecr_projects) :
    p => module.project_ecr[p].ecr_url
  }
}

output all_subnet_ids {
  description = "subnet ids from vpc created"
  value       = local.cluster_subnet_ids
}

output public_subnet_ids {
  description = "public subnet ids from vpc created"
  value       = local.cluster_public_subnet_ids
}

output private_subnet_ids {
  description = "private subnet ids from vpc created"
  value       = local.cluster_private_subnet_ids
}

output nat_eip {
  description = "NAT public ip created"
  value       = local.cluster_vpc_nat_eip
}

output cluster_endpoint {
  description = "The endpoint for your Kubernetes API server"
  value       = module.cluster_control_plane.endpoint
}

output cluster_certificate_authority_data {
  description = "The base64 encoded certificate data required to communicate with your cluster. Add this to the certificate-authority-data section of the kubeconfig file for your cluster."
  value       = module.cluster_control_plane.certificate_authority_data
}

output worker_node_ids {
  description = "Map of created worker nodes in the cluster, return worker node name and id"
  value       = module.cluster_worker_nodes.ids
}
