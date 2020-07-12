resource "aws_instance" "my_web_server" {
  ami           = lookup(var.ami_id, var.region)
  instance_type = "t2.micro"
}
