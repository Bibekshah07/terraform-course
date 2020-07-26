data "aws_iam_role" "host_role_jenkins" {
  name   = var.host_role_jenkins
}

data "aws_iam_role_policy" "instance_role_policy_jenkins" {
  name   = var.instance_role_policy_jenkins
  role   = aws_iam_role.host_role_jenkins.id
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "iam_instance_profile_${var.ecs_cluster_name}"
  path = "/"
  role = aws_iam_role.host_role_jenkins.name
}
