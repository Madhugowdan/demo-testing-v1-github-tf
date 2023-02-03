
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.51.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "tf-state" {
  source      = "./modules/s3-bucket"
  bucket_name = "app-webservice-github-workflow-terraform-tfstate-v1"
  #region      = "eu-west-1"
}
