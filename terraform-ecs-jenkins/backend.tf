terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "terraformstatekant"
    key    = "jenkins/terraform.tfstate"
  }
}
