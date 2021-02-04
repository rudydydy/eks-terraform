variable aws_region {
  description = "Your aws region preference"
  type        = string
}

variable cluster_name {
  description = "EKS cluster name"
  type        = string
}

# reference: https://docs.aws.amazon.com/eks/latest/userguide/platform-versions.html
variable k8s_version {
  description = "kubernetes version"
  type        = string
}

variable cluster_public_access_cidrs {
  description = "List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0"
  type        = list
  default     = ["0.0.0.0/0"]
}

variable endpoint_private_access {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default is false"
  type        = bool
  default     = false
}

variable endpoint_public_access {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default is true"
  type        = bool
  default     = true
}

variable cluster_tags {
  description = "EKS tags"
  type        = map
  default     = {}
}

################################################################################
# EKS Node Group
# - reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
# - map type variable, key is worker node name and inside key is that worker node configuration setting
################################################################################
variable worker_nodes {
  description = "Map of worker nodes managed by EKS cluster"
  type        = map
  default     = {
    web = {
      # set your node group instances subnet, if you need static public ip then consider using private subnet (NAT)
      # NOTE: beware of data transfer cost
      subnet_type = "private"
      instance_types = ["t3.small"]
      capacity_type = "SPOT",
      disk_size = 10,
      force_update_version = false,
      scaling_config = {
        desired_size = 2
        max_size = 3
        min_size = 1
      }
      kubernetes_labels = {
        "service": "web"
      }
      tags = {
        "service": "web"
      }
    },
    loadbalancer = {
      subnet_type = "public"
      instance_types = ["t3.small"]
      capacity_type = "SPOT",
      disk_size = 10,
      force_update_version = false,
      scaling_config = {
        desired_size = 2
        max_size = 3
        min_size = 1
      }
      kubernetes_labels = {
        "service": "loadbalancer"
      }
      tags = {
        "service": "loadbalancer"
      }
    }
  }
}

################################################################################
# ECR Variable (Optional)
# - reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository
# - map type variable, key is ECR repository name and inside key is that repository configuration setting
################################################################################
variable ecr_projects {
  description = "(Optional) Map of project names to configuration"
  type        = map
  default     = {
    alpha = {
      image_tag_mutability = "MUTABLE",
      scan_on_push         = false
    }
  }
}

################################################################################
# VPC Variable (Optional)
# - fill bellow value if you want to use existing vpc
# - if not provided then this terraform gonna create a new vpc for you (vpc, nat, igw, public and private subnet)
################################################################################
variable new_vpc_cidr_block {
  description = "New VPC creatd for EKS cluster, if variable 'vpc_name' not blank this variable will be ignored"
  type        = string
  default     = "10.0.0.0/16" 
}

# if you decide to use existing vpc already created, then please override below variables default value
# also consider reading below docs https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
# in summary, EKS need your subnets to include custom tagging
variable vpc_id {
  description = "AWS VPC id"
  type        = string
  default     = ""
}

variable cluster_subnet_ids {
  description = "(Optional) List of EKS cluster subnet ids"
  type        = list
  default     = []
}

variable cluster_public_subnet_ids {
  description = "(Optional) List of EKS cluster public subnet ids"
  type        = list
  default     = []
}

variable cluster_private_subnet_ids {
  description = "(Optional) List of EKS cluster private subnet ids"
  type        = list
  default     = []
}
