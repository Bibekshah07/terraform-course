output "fqdn_name" {
  value = aws_route53_zone.jenkins.name
}
output "certificate_arn" {
  value = aws_acm_certificate.jenkins.arn
}
