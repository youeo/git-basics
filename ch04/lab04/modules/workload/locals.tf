locals {
  namespace = var.namespace

  instance = {
    name = "web"

    instance_type = "t3.small"
    ami           = data.aws_ami.amazon_linux.id

    associate_public_ip_address = true
    vpc_id                      = var.instance_vpc_id
    subnet_id                   = var.instance_subnet_id

    iam_instance_profile = var.instance_iam_instance_profile

    allow_access = {
      port        = 80
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}