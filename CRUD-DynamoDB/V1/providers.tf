terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.64.0"
    }
    archive = {
      source = "hashicorp/archive"
      version = "2.5.0"
    }

  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.global_tags
  }
}
