provider "aws" {}

resource "aws_instance" "linux_created_by_TF" {
  count         = 1
  ami           = "ami-0d8f9265cd415c863" # Amazon AMI
  instance_type = "t2.micro"

  tags = {
    Name  = "HelloWorld"
    Owner = "Hov-TF"
  }
}
