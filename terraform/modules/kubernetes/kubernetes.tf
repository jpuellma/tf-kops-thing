output "cluster_name" {
  value = "test.jpuellma.net"
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-test-jpuellma-net.id}"]
}

output "masters_role_arn" {
  value = "${aws_iam_role.masters-test-jpuellma-net.arn}"
}

output "masters_role_name" {
  value = "${aws_iam_role.masters-test-jpuellma-net.name}"
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-test-jpuellma-net.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.us-east-1b-test-jpuellma-net.id}", "${aws_subnet.us-east-1c-test-jpuellma-net.id}", "${aws_subnet.us-east-1d-test-jpuellma-net.id}"]
}

output "nodes_role_arn" {
  value = "${aws_iam_role.nodes-test-jpuellma-net.arn}"
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-test-jpuellma-net.name}"
}

output "region" {
  value = "us-east-1"
}

output "vpc_id" {
  value = "${aws_vpc.test-jpuellma-net.id}"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_autoscaling_group" "master-us-east-1d-masters-test-jpuellma-net" {
  name                 = "master-us-east-1d.masters.test.jpuellma.net"
  launch_configuration = "${aws_launch_configuration.master-us-east-1d-masters-test-jpuellma-net.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.us-east-1d-test-jpuellma-net.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "test.jpuellma.net"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-east-1d.masters.test.jpuellma.net"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "master-us-east-1d"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_autoscaling_group" "nodes-test-jpuellma-net" {
  name                 = "nodes.test.jpuellma.net"
  launch_configuration = "${aws_launch_configuration.nodes-test-jpuellma-net.id}"
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = ["${aws_subnet.us-east-1b-test-jpuellma-net.id}", "${aws_subnet.us-east-1c-test-jpuellma-net.id}", "${aws_subnet.us-east-1d-test-jpuellma-net.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "test.jpuellma.net"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.test.jpuellma.net"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "nodes"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_ebs_volume" "d-etcd-events-test-jpuellma-net" {
  availability_zone = "us-east-1d"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                         = "test.jpuellma.net"
    Name                                      = "d.etcd-events.test.jpuellma.net"
    "k8s.io/etcd/events"                      = "d/d"
    "k8s.io/role/master"                      = "1"
    "kubernetes.io/cluster/test.jpuellma.net" = "owned"
  }
}

resource "aws_ebs_volume" "d-etcd-main-test-jpuellma-net" {
  availability_zone = "us-east-1d"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                         = "test.jpuellma.net"
    Name                                      = "d.etcd-main.test.jpuellma.net"
    "k8s.io/etcd/main"                        = "d/d"
    "k8s.io/role/master"                      = "1"
    "kubernetes.io/cluster/test.jpuellma.net" = "owned"
  }
}

resource "aws_iam_instance_profile" "masters-test-jpuellma-net" {
  name = "masters.test.jpuellma.net"
  role = "${aws_iam_role.masters-test-jpuellma-net.name}"
}

resource "aws_iam_instance_profile" "nodes-test-jpuellma-net" {
  name = "nodes.test.jpuellma.net"
  role = "${aws_iam_role.nodes-test-jpuellma-net.name}"
}

resource "aws_iam_role" "masters-test-jpuellma-net" {
  name               = "masters.test.jpuellma.net"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.test.jpuellma.net_policy")}"
}

resource "aws_iam_role" "nodes-test-jpuellma-net" {
  name               = "nodes.test.jpuellma.net"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.test.jpuellma.net_policy")}"
}

resource "aws_iam_role_policy" "masters-test-jpuellma-net" {
  name   = "masters.test.jpuellma.net"
  role   = "${aws_iam_role.masters-test-jpuellma-net.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.test.jpuellma.net_policy")}"
}

resource "aws_iam_role_policy" "nodes-test-jpuellma-net" {
  name   = "nodes.test.jpuellma.net"
  role   = "${aws_iam_role.nodes-test-jpuellma-net.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.test.jpuellma.net_policy")}"
}

resource "aws_internet_gateway" "test-jpuellma-net" {
  vpc_id = "${aws_vpc.test-jpuellma-net.id}"

  tags = {
    KubernetesCluster                         = "test.jpuellma.net"
    Name                                      = "test.jpuellma.net"
    "kubernetes.io/cluster/test.jpuellma.net" = "owned"
  }
}

resource "aws_key_pair" "kubernetes-test-jpuellma-net-e98776548dba71eceb82ed0ec104c76f" {
  key_name   = "kubernetes.test.jpuellma.net-e9:87:76:54:8d:ba:71:ec:eb:82:ed:0e:c1:04:c7:6f"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.test.jpuellma.net-e98776548dba71eceb82ed0ec104c76f_public_key")}"
}

resource "aws_launch_configuration" "master-us-east-1d-masters-test-jpuellma-net" {
  name_prefix                 = "master-us-east-1d.masters.test.jpuellma.net-"
  image_id                    = "ami-dbd611a6"
  instance_type               = "m3.medium"
  key_name                    = "${aws_key_pair.kubernetes-test-jpuellma-net-e98776548dba71eceb82ed0ec104c76f.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-test-jpuellma-net.id}"
  security_groups             = ["${aws_security_group.masters-test-jpuellma-net.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-east-1d.masters.test.jpuellma.net_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  ephemeral_block_device = {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_launch_configuration" "nodes-test-jpuellma-net" {
  name_prefix                 = "nodes.test.jpuellma.net-"
  image_id                    = "ami-dbd611a6"
  instance_type               = "t2.medium"
  key_name                    = "${aws_key_pair.kubernetes-test-jpuellma-net-e98776548dba71eceb82ed0ec104c76f.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-test-jpuellma-net.id}"
  security_groups             = ["${aws_security_group.nodes-test-jpuellma-net.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.test.jpuellma.net_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_route" "0-0-0-0--0" {
  route_table_id         = "${aws_route_table.test-jpuellma-net.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.test-jpuellma-net.id}"
}

resource "aws_route_table" "test-jpuellma-net" {
  vpc_id = "${aws_vpc.test-jpuellma-net.id}"

  tags = {
    KubernetesCluster                         = "test.jpuellma.net"
    Name                                      = "test.jpuellma.net"
    "kubernetes.io/cluster/test.jpuellma.net" = "owned"
    "kubernetes.io/kops/role"                 = "public"
  }
}

resource "aws_route_table_association" "us-east-1b-test-jpuellma-net" {
  subnet_id      = "${aws_subnet.us-east-1b-test-jpuellma-net.id}"
  route_table_id = "${aws_route_table.test-jpuellma-net.id}"
}

resource "aws_route_table_association" "us-east-1c-test-jpuellma-net" {
  subnet_id      = "${aws_subnet.us-east-1c-test-jpuellma-net.id}"
  route_table_id = "${aws_route_table.test-jpuellma-net.id}"
}

resource "aws_route_table_association" "us-east-1d-test-jpuellma-net" {
  subnet_id      = "${aws_subnet.us-east-1d-test-jpuellma-net.id}"
  route_table_id = "${aws_route_table.test-jpuellma-net.id}"
}

resource "aws_security_group" "masters-test-jpuellma-net" {
  name        = "masters.test.jpuellma.net"
  vpc_id      = "${aws_vpc.test-jpuellma-net.id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster                         = "test.jpuellma.net"
    Name                                      = "masters.test.jpuellma.net"
    "kubernetes.io/cluster/test.jpuellma.net" = "owned"
  }
}

resource "aws_security_group" "nodes-test-jpuellma-net" {
  name        = "nodes.test.jpuellma.net"
  vpc_id      = "${aws_vpc.test-jpuellma-net.id}"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster                         = "test.jpuellma.net"
    Name                                      = "nodes.test.jpuellma.net"
    "kubernetes.io/cluster/test.jpuellma.net" = "owned"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-test-jpuellma-net.id}"
  source_security_group_id = "${aws_security_group.masters-test-jpuellma-net.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-test-jpuellma-net.id}"
  source_security_group_id = "${aws_security_group.masters-test-jpuellma-net.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-test-jpuellma-net.id}"
  source_security_group_id = "${aws_security_group.nodes-test-jpuellma-net.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "https-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-test-jpuellma-net.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-test-jpuellma-net.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-test-jpuellma-net.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-test-jpuellma-net.id}"
  source_security_group_id = "${aws_security_group.nodes-test-jpuellma-net.id}"
  from_port                = 1
  to_port                  = 2379
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-test-jpuellma-net.id}"
  source_security_group_id = "${aws_security_group.nodes-test-jpuellma-net.id}"
  from_port                = 2382
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-test-jpuellma-net.id}"
  source_security_group_id = "${aws_security_group.nodes-test-jpuellma-net.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-test-jpuellma-net.id}"
  source_security_group_id = "${aws_security_group.nodes-test-jpuellma-net.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-test-jpuellma-net.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-test-jpuellma-net.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_subnet" "us-east-1b-test-jpuellma-net" {
  vpc_id            = "${aws_vpc.test-jpuellma-net.id}"
  cidr_block        = "172.20.32.0/19"
  availability_zone = "us-east-1b"

  tags = {
    KubernetesCluster                         = "test.jpuellma.net"
    Name                                      = "us-east-1b.test.jpuellma.net"
    SubnetType                                = "Public"
    "kubernetes.io/cluster/test.jpuellma.net" = "owned"
    "kubernetes.io/role/elb"                  = "1"
  }
}

resource "aws_subnet" "us-east-1c-test-jpuellma-net" {
  vpc_id            = "${aws_vpc.test-jpuellma-net.id}"
  cidr_block        = "172.20.64.0/19"
  availability_zone = "us-east-1c"

  tags = {
    KubernetesCluster                         = "test.jpuellma.net"
    Name                                      = "us-east-1c.test.jpuellma.net"
    SubnetType                                = "Public"
    "kubernetes.io/cluster/test.jpuellma.net" = "owned"
    "kubernetes.io/role/elb"                  = "1"
  }
}

resource "aws_subnet" "us-east-1d-test-jpuellma-net" {
  vpc_id            = "${aws_vpc.test-jpuellma-net.id}"
  cidr_block        = "172.20.96.0/19"
  availability_zone = "us-east-1d"

  tags = {
    KubernetesCluster                         = "test.jpuellma.net"
    Name                                      = "us-east-1d.test.jpuellma.net"
    SubnetType                                = "Public"
    "kubernetes.io/cluster/test.jpuellma.net" = "owned"
    "kubernetes.io/role/elb"                  = "1"
  }
}

resource "aws_vpc" "test-jpuellma-net" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster                         = "test.jpuellma.net"
    Name                                      = "test.jpuellma.net"
    "kubernetes.io/cluster/test.jpuellma.net" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "test-jpuellma-net" {
  domain_name         = "ec2.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster                         = "test.jpuellma.net"
    Name                                      = "test.jpuellma.net"
    "kubernetes.io/cluster/test.jpuellma.net" = "owned"
  }
}

resource "aws_vpc_dhcp_options_association" "test-jpuellma-net" {
  vpc_id          = "${aws_vpc.test-jpuellma-net.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.test-jpuellma-net.id}"
}

terraform = {
  required_version = ">= 0.9.3"
}
