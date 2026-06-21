data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config = {
    bucket = var.infrastructure_state_bucket
    key    = var.infrastructure_state_key
    region = var.aws_region
  }
}

data "aws_eks_cluster" "this" {
  name = data.terraform_remote_state.infrastructure.outputs.eks_cluster_name
}