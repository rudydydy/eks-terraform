variable "aws_region" {
  description = "Your aws region preference"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

# ECR reference: 
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository
variable project {
  description = "Map of project names to configuration"
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
