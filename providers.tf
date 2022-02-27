provider "aws" {
  region = "us-west-2"

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

terraform {
  required_providers {
    remote = {
      source  = "tenstad/remote"
      version = "0.0.23"
    }
  }
}

provider "remote" {
  # Configuration options
  max_sessions = 1
}
