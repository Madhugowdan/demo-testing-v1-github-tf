module "ec2-complete" {
  source = "./modules/ec2-complete"

}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.51.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-statefile-githubaction-workflow-v1"
    key    = "ec2-tfstate/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "terraform-state-locking-s3-tfstate"
  }
}
