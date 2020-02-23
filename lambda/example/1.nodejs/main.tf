# Assign the region to the provider in this case AWS
provider "aws" {
  region = "${var.aws_region}"
}

# Archive the code or project that we want to run
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "src/index.js"
  output_path = "lambda_function.zip"
}
