provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    # unable to dynamically inject terraform variable
    # terraform backend bucket must be hardcoded
    bucket = "<CHANGE_ME_BUCKET>"
    key    = "terraform/eks/state"
    # based on var.aws_region
    region = "<CHANGE_ME_REGION>"
  }
}

################################################################################
# ECR resources
# - Registry
# - Lifecycle Policy (TODO)
################################################################################
module "project_ecr" {
  source   = "./modules/project_ecr"
  for_each = var.ecr_projects

  repository_name      = each.key
  image_tag_mutability = each.value.image_tag_mutability
  scan_on_push         = each.value.scan_on_push
}

################################################################################
# VPC Resources
# - VPC
# - Subnet
# - IGW
# - NAT
# - Route table
################################################################################
data "aws_vpc" "selected" {
  count = var.vpc_name == "" ? 0 : 1
  tags  = {
    "Name" = var.vpc_name
  }
}

data "aws_subnet_ids" "selected" {
  count = var.vpc_name == "" ? 0 : 1
  vpc_id = data.aws_vpc.selected[0].id
}

module "cluster_vpc" {
  count        = var.vpc_name == "" ? 1 : 0
  source       = "./modules/cluster_vpc"
  cluster_name = var.cluster_name 
  cidr_block   = var.new_vpc_cidr_block
}

################################################################################
# EKS Cluster (Control Plane)
################################################################################
# module "cluster_control_plane" {
#   source       = "./modules/cluster_control_plane"
#   cluster_name = var.cluster_name
# }
