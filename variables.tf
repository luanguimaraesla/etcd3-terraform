variable "s3_bucket_name" {
  type = string
  description = "S3 bucket name to store etcd bootstrap files"
}

variable "s3_bucket_prefix" {
  type = string
  default = "etcd"
  description = "S3 object prefix to store etcd bootstrap files"
}

variable "instance_type" {
  default = "m5.large"
  description = "AWS instance type"
}

variable "azs" {
  default = []
  type = list
  description = "List of AWS availability zones. Make sure you have more than three zones for HA setup"
}

variable "tags" {
  default = {}
  type = map
  description = "AWS tags which will be present in all cloud resources"
}

variable "role" {
  default     = "etcd3"
  description = "Used to describe the function of a particular node (web server, database server, load balancer, etc.)."
  type        = string
}

variable "ami" {
  default = "ami-1f62c270"
  type = string
  description = "AWS AMI ID to use"
}

variable "vpc_id" {
  type = string
  description = "AWS VPC to create all resources"
}

variable "vpc_cidr_block" {
  type = string
  description = "AWS VPC CIDR Block for opening security groups"
}

variable "dns" {
  type = map(string)

  default = {
    domain_name = "cilium.internal"
  }
}

variable "root_key_pair_public_key" {
  type = string
  description = "AWS key pair public key to attach to instances"
}

variable "cluster_size" {
  default = 3
  description = "ETCD cluster size. Maximum: 5"
}

variable "ntp_host" {
  default = "0.europe.pool.ntp.org"
  description = "NTP host you want to use within etcd instances"
}
