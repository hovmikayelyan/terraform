provider "aws" {
  region = "eu-west-3"
}

resource "aws_instance" "node1" {
  ami           = "ami-00ae10ea2db12689d"
  instance_type = "t2.micro"
  tags = {
    Name = "tf-test"
  }
}


#run terraform apply -replace="aws_instance.node1" |OR| terraform taint aws_instance.node1 , then terraform apply