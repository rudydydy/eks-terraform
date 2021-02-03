output ids {
  description = "Map of worker node ids"
  value       = {
    for w in keys(var.worker_nodes) :
    w => aws_eks_node_group.main[w].id
  }
}
