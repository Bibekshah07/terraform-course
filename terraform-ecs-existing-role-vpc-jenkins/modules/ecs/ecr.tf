resource "aws_ecr_repository" "jenkins" {
  name = var.image_name
  tags = {
    Name = "${var.image_name}_ecr"
  }
}

data "aws_ecr_repository" "jenkins" {
  name = var.image_name
}

resource "null_resource" "jenkins" {
  triggers = {
    build_trigger = var.build_trigger
  }
  provisioner "local-exec" {
    command     = "./deploy-image.sh ${var.region} ${var.image_name} ${aws_ecr_repository.jenkins.repository_url}"
    interpreter = ["bash", "-c"]
    working_dir = "${path.cwd}/${path.module}"
  }
}
