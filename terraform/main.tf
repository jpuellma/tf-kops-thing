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
//module "kops" {
//  source = "./modules/kops"
//}


// module created by kops:
module "kubernetes" {
  source = "./modules/kubernetes"
}


// Allow inbound traffic to reach k8s nodes
resource "aws_security_group_rule" "allow-inbound-to-k8s-nodes" {
//  count           = "${length(module.kubernetes.node_security_group_ids)}"
// TODO: Get the correct value of 'count' here without hard coding it.
  count           = 1

  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${element(module.kubernetes.node_security_group_ids, count.index)}"
}