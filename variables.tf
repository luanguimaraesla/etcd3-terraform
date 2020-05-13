variable "name" {
  type = string
  description = "This value will be appended to '.etcd' and prefixed to resource names and also to the R53 domain"
}

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
  type = list
  description = "List of AWS availability zones. Make sure you have more than three zones for HA setup"
}

variable "subnet_ids" {
  type = list
  description = "List of AWS subnet IDs to setup the ELB for the ETCD cluster"
}

variable "tags" {
  default = {}
  type = map
  description = "AWS tags which will be present in all cloud resources"
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

variable "route53_zone_id" {
  type = string
  description = "Route53 Zone ID for creating internal DNS records"
}

variable "key_name" {
  type = string
  description = "AWS key pair public key to attach to instances"
}

variable "ntp_host" {
  default = "0.north-america.pool.ntp.org"
  description = "NTP host you want to use within etcd instances"
}
