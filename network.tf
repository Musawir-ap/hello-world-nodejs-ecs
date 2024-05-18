data "aws_vpc" "default" {
  default = true
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = "172.31.96.0/20"  # Use a valid CIDR block within the VPC range
  availability_zone = "ap-south-1a"
}

resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Managed by Terraform"
  vpc_id      = data.aws_vpc.default.id

  // Define your security group rules here
}