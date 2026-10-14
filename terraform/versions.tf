terraform {
  required_version = ">= 1.6"

  required_providers {
    aws    = { source = "hashicorp/aws", version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.6" }
  }

  # État distant (recommandé en équipe) : créer d'abord un bucket S3, puis décommenter
  # backend "s3" {
  #   bucket = "mon-bucket-tfstate"
  #   key    = "personnes/terraform.tfstate"
  #   region = "eu-west-3"
  # }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = { Project = var.project, ManagedBy = "terraform" }
  }
}
