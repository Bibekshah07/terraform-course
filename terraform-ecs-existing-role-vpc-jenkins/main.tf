provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

module "ecs" {
  source                    = "./modules/ecs"
  region                    = var.region
  image_name                = var.image_name
  restore_backup            = var.restore_backup
  ecs_cluster_name          = var.ecs_cluster_name
  s3_bucket                 = var.s3_bucket
  aws_profile               = var.aws_profile
  container_port            = var.container_port
  agent_port                = var.agent_port
  ec2_security_group        = var.aws_security_group_jenkins_ecs_id
  aws_iam_instance_profile  = var.iam_role_jenkins
  key_name                  = var.key_name
  instance_type             = var.instance_type
  amis                      = var.amis
  aws_security_group        = var.aws_security_group_jenkins_ecs_id
  vpc_zone_identifier       = split( ",", var.alb_subnet_ids)
  availability_zone         = var.availability_zone
  min_instance_size         = var.min_instance_size
  max_instance_size         = var.max_instance_size
  desired_instance_capacity = var.desired_instance_capacity
  target_group_arn          = aws_alb_target_group.jenkins.0.arn
  desired_service_count     = var.desired_service_count
  jenkins_repository_url    = var.jenkins_repository_url
  build_trigger             = var.build_trigger
}

module "dns" {
  source                           = "./modules/dns"
  region                           = var.region
  aws_dns_zone_holder_profile_name = var.aws_dns_zone_holder_profile_name
  aws_dns_name                     = aws_alb.jenkins.dns_name
  aws_dns_zone                     = aws_alb.jenkins.zone_id
  dns_zone_name                    = var.dns_zone_name
  subdomain_zone_name              = var.subdomain_zone_name

}
