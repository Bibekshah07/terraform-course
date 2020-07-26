resource "aws_route53_zone" "jenkins" {
  name = "${var.subdomain_zone_name}.${var.dns_zone_name}"
}

resource "aws_route53_record" "jenkins" {
  zone_id = aws_route53_zone.jenkins.id
  name    = "${var.subdomain_zone_name}.${var.dns_zone_name}"
  type    = "A"

  alias {
    name                   = var.aws_dns_name
    zone_id                = var.aws_dns_zone
    evaluate_target_health = true
  }
}


resource "aws_route53_record" "jenkins_certification" {
  name    = aws_acm_certificate.jenkins.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.jenkins.domain_validation_options[0].resource_record_type
  zone_id = aws_route53_zone.jenkins.id
  records = [
  aws_acm_certificate.jenkins.domain_validation_options[0].resource_record_value]
  ttl = 60
  depends_on = [
    aws_route53_zone.jenkins
  ]
}

### Set in the AWS Account where the partent zone is hosted ###
resource "aws_route53_record" "ns_main_zone_ownership" {
  provider = aws.dns_zone_holder_account
  name     = "${var.subdomain_zone_name}.${var.dns_zone_name}"
  type     = "NS"
  zone_id  = data.aws_route53_zone.main_parent_zone.zone_id
  records  = aws_route53_zone.jenkins.name_servers
  ttl      = 300
}

data "aws_route53_zone" "main_parent_zone" {
  provider = aws.dns_zone_holder_account
  name     = var.dns_zone_name
}
