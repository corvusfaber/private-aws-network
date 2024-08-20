terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "mlclmfrsr-tfstate"
    dynamodb_table = "terraform-state-lock-dynamo"
    key            = "state/network.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "network_infrastructure" {
  source = "./modules/infrastructure"

  vpc_name                  = "mf-vpc"
  vpc_cidr_block            = "10.0.0.0/16"
  public_subnet_cidr_block  = "10.0.1.0/24"
  private_subnet_cidr_block = "10.0.2.0/24"
}