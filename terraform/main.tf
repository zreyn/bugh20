variable "aws_region" {
  default = "us-east-2"
}

variable "azs" {
  description = "list of aws availabilty zones in aws region"
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
  type        = list(any)
}

data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "bug_h20_tf_state" {
  bucket = "bug-h20-tf-state"
  versioning {
    enabled = true
  }
  tags = {
    Name = "terraform store for bug-h20"
  }
}

terraform {
  required_version = ">= 0.13.0"
  backend "s3" {
    region = "us-east-2"
    bucket = "bug-h20-tf-state"
    key    = "bug-h20-tf.tfstate"
  }
}