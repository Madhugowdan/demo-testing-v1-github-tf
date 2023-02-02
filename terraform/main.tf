
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

terraform {
  backend "s3" {
    bucket         = "app-webservice-github-workflow-terraform-tfstate-v1"
    key            = "ec2-tfstate/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-locking-s3-tfstate"
  }
}

module "ec2-complete" {
  source = "./modules/ec2-complete"

}