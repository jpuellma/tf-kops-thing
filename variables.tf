# Global config

variable "region" {
  description = "Enter AWS Region [us-east-1]"
  default = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the cluster (subdomain.jpuellma.net)"
  default = "test"
}
