provider "aws" {
  alias   = "acr_region"
  region  = var.region
  version = "~> 2.31"
}

provider "aws" {
  alias   = "dns_zone_holder_account"
  region  = var.region
  profile = var.aws_dns_zone_holder_profile_name
}
