terraform {
  backend "s3" {
    bucket = "jpuellma-net-general"
    key = "tf-backend"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}


// kops group
module "kops" {
  source = "./modules/kops"
}


// module created by kops:
module "kubernetes" {
  source = "./modules/kubernetes"
}
