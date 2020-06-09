variable "name" {
  type = string
  description = "This value will be appended to '.etcd' and prefixed to resource names and also to the R53 domain"
}

variable "region" { 
  type = string
  description = "AWS region"
}

variable "environment" {
  type = string
  description = "Workload environment"
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

variable "azs_subnet_ids" {
  type = map(string) 
  description = "Map of AWS subnet names and respective IDs to setup the ELB and ASGs for the ETCD cluster"
}

variable "tags" {
  default = {}
  type = map
  description = "AWS tags which will be present in all cloud resources"
}

variable "ami" {
  default = "ami-068663a3c619dd892"
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
