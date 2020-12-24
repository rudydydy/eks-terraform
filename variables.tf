variable "aws_region" {
  description = "Your aws region preference"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
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
variable vpc_name {
  description = "(Optional) VPC name already exist in your AWS account, ex: 'default'"
  type        = string
  default     = ""
}
