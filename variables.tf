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
  # default     = ["0.0.0.0/0"]
  default     = ["35.201.197.198/32"]
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
    },
    beta = {
      image_tag_mutability = "IMMUTABLE",
      scan_on_push         = true
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

# if you decide to use existing vpc already created, then consider reading below docs
# https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
# in summary, EKS need your subnets to include custom tagging
variable vpc_name {
  description = "(Optional) VPC name already exist in your AWS account, ex: 'default'"
  type        = string
  default     = ""
}
