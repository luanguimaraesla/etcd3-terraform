provider "aws" {
  region = "eu-central-1"
}

variable "instance_type" {
  default = "m5.large"
}

variable "region" {
  default = "eu-central-1"
}

variable "azs" {
  default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "environment" {
  default = "staging"
}

variable "role" {
  default = "etcd3-test"
}

variable "ami" {
  default = "ami-1f62c270"
}

variable "vpc_cidr" {
  default = "10.200.0.0/16"
}

variable "dns" {
  type = map(string)

  default = {
    domain_name = "cilium.internal"
  }
}

variable "root_key_pair_public_key" {
}

variable "cluster_size" {
  default = 3
}

variable "ntp_host" {
  default = "0.europe.pool.ntp.org"
}

