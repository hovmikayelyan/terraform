#null resourse
#local-exec


provider "aws" {
  region = "eu-west-3"
}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command     = "echo Terraform START: $(Get-Date) >> log.txt"
    interpreter = ["PowerShell", "-Command"]
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command = "ping www.google.com"
  }
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    command = "print('Hello World!')"
    interpreter = [
      "python", "-c"
    ]
  }
}

resource "null_resource" "command4" {
  provisioner "local-exec" {
    command = "echo $VAR_NAME is $something >> var.txt"

    environment = {
      VAR_NAME  = "my variable name"
      something = "oo la la"
    }
  }
}


resource "aws_instance" "myserver" {
  ami           = "ami-06b6c7fea532f597e"
  instance_type = "t2.micro"
  provisioner "local-exec" {
    command = "echo Hello from AWS insance creation!"
  }
}

resource "null_resource" "command6" {
  provisioner "local-exec" {
    command = "echo Terraform END: $(date) >> log.txt"
  }
  depends_on = [
    null_resource.command1,
    null_resource.command2,
    null_resource.command3,
    null_resource.command4,
    aws_instance.myserver
  ]
}
