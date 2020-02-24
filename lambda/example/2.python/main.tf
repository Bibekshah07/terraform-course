# Assign the region to the provider in this case AWS
provider "aws" {
  region = "${var.aws_region}"
}

#This Step is a null resource, that executes the build.sh
resource "null_resource" "lambda_buildstep" {
  triggers = {
    handler      = "${base64sha256(file("src/lambda_function.py"))}"
    requirements = "${base64sha256(file("src/requirements.txt"))}"
    build        = "${base64sha256(file("src/build.sh"))}"
  }

  provisioner "local-exec" {
    command = "${path.module}/src/build.sh"
  }
}

# Archive the code or project that we want to run
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src/"
  output_path = "${path.module}/src/python_1_lambda_function.zip"

  depends_on = ["null_resource.lambda_buildstep"]
}
