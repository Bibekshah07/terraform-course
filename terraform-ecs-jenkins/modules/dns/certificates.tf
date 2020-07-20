resource "aws_acm_certificate" "jenkins" {
  domain_name       = "${var.subdomain_zone_name}.${var.dns_zone_name}"
  validation_method = "DNS"
  depends_on = [
    aws_route53_zone.jenkins
  ]
}

resource "aws_acm_certificate_validation" "jenkins" {
  certificate_arn         = aws_acm_certificate.jenkins.arn
  validation_record_fqdns = [aws_route53_record.jenkins_certification.fqdn]
  depends_on = [
    aws_acm_certificate.jenkins
  ]
}
