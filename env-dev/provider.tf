terraform {
  backend "s3" {}

  required_version = "= 0.11.10"
}

provider "aws" {
  version = "v1.57.0"
  region = "eu-west-1"
}
