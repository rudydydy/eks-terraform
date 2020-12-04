output project_ecr_url {
  description = "List created AWS ECR, outputting project name and repository url" 
  value       = { 
    for p in sort(keys(var.project)) : 
    p => module.project_ecr[p].ecr_url 
  }
}