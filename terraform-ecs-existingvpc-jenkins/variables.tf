variable "aws_profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "image_name" {
  type    = string
  default = "jenkins"
}

variable "availability_zone" {
  description = "The availability zone"
  default     = "us-east-1b"
}

variable "ecs_cluster_name" {
  description = "The name of the Amazon ECS cluster."
  default     = "jenkins-ecs"
}

variable "amis" {
  description = "Which AMI to spawn. Defaults to the AWS ECS optimized images."
  default = {
    us-east-1 = "ami-08b26b905b0d17561"
  }
}

variable "instance_type" {
  default = "t3.medium"
}

variable "key_name" {
  default     = "kantlearning"
  description = "SSH key name in your AWS account for AWS instances."
}

variable "min_instance_size" {
  default     = 1
  description = "Minimum number of EC2 instances."
}

variable "max_instance_size" {
  default     = 2
  description = "Maximum number of EC2 instances."
}

variable "desired_instance_capacity" {
  default     = 1
  description = "Desired number of EC2 instances."
}

variable "desired_service_count" {
  default     = 1
  description = "Desired number of ECS services."
}

variable "s3_bucket" {
  default     = "terraformstatekant"
  description = "S3 bucket where remote state and Jenkins data will be stored."
}

variable "restore_backup" {
  default     = true
  description = "Whether or not to restore Jenkins backup."
}

variable "jenkins_repository_url" {
  default     = "jenkins"
  description = "ECR Repository for Jenkins."
}

variable "container_port" {
  default     = "8080"
  description = "Docker Container Port."
}

variable "agent_port" {
  default     = "50000"
  description = "Jenins Agent Port."
}

variable "aws_dns_zone_holder_profile_name" {
  type        = string
  default     = "default"
  description = "Local AWS profile to use for the AWS account where the dns zone is maintaned"
}

variable "subdomain_zone_name" {
  type    = string
  default = "jenkins"
}

variable "dns_zone_name" {
  type    = string
  default = "kantlearning.com"
}

variable "hosts_name" {
  type    = string
  default = "*.kantlearning.com"
}

variable "build_trigger" {
  default = "18"
}

variable "host_role_jenkins" {
  type    = string
  default = "*.kantlearning.com"
}

variable "instance_role_policy_jenkins" {
  type    = string
  default = "*.kantlearning.com"
}

