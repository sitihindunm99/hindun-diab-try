# Store state file locally
#terraform {
#    backend "local" {}
#}

# Store state file on S3
terraform {
    backend "s3" {
        region = "ap-southeast-1" // Variables cannot be used here
        bucket = "diab-state-file-sample"
        key    = "test.tfstate"
    }
}
#

# Indicate Terraform and Provider versions
terraform {
    required_version = ">= 1.0.0"
    required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 3.74"
        }
#        local = {
#            source  = "hashicorp/local"
#            version = "2.1.0"
#        }
    }
}

# Configuration options
provider "aws" {
    region = var.region
}