output project_ecr_url {
  description = "List created AWS ECR, outputting project name and repository url"
  value       = {
    for p in sort(keys(var.ecr_projects)) :
    p => module.project_ecr[p].ecr_url
  }
}

output vpc_id {
  description = "VPC id created"
  value       = var.vpc_name == "" ? module.cluster_vpc[0].vpc_id : data.aws_vpc.selected[0].id
}

output all_subnet_ids {
  description = "subnet ids from vpc created"
  value       = var.vpc_name == "" ? module.cluster_vpc[0].all_subnet_ids : data.aws_subnet_ids.selected[0].ids
}

output public_subnet_ids {
  description = "public subnet ids from vpc created"
  value       = var.vpc_name == "" ? module.cluster_vpc[0].public_subnet_ids : "use existing vpc"
}

output private_subnet_ids {
  description = "private subnet ids from vpc created"
  value       = var.vpc_name == "" ? module.cluster_vpc[0].private_subnet_ids : "use existing vpc"
}

output nat_eip {
  description = "NAT public ip created"
  value       = var.vpc_name == "" ? module.cluster_vpc[0].nat_eip : "use existing vpc"
}
