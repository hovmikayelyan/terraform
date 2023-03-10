#создать динамические блоки в динамических блоках?

dynamic "rule" {
  for_each = var.rules
  content {
    name     = lookup(rule.value, "name")
    priority = lookup(rule.value, "priority")

    override_action {
      dynamic "none" {
        for_each = length(lookup(rule.value, "override_action", {})) == 0 || lookup(rule.value, "override_action", {}) == "none" ? [1] : []
        content {}
      }

      dynamic "count" {
        for_each = lookup(rule.value, "override_action", {}) == "count" ? [1] : []
        content {}
      }
    }

  }
}


#Для тех, кто хочет использовать не только обычный массив стандартных типов (string, number).

resource "aws_security_group" "web-server" {

  name = "allow_web_server"

  description = "Allow web server http/https"



  dynamic "ingress" {

    for_each = [

      {

        port = "80",

        description = "web from internet",

        protocol = "tcp"

      },

      {

        port = "443",

        description = "web from internet",

        protocol = "tcp"

      },

      {

        port = "8080",

        description = "web from internet",

        protocol = "tcp"

      },

      {

        port = "8090",

        description = "web from internet",

        protocol = "tcp"

      },

    ]

    content {

      description = ingress.value.description

      from_port = ingress.value.port

      to_port = ingress.value.port

      protocol = ingress.value.protocol

      cidr_blocks = ["0.0.0.0/0"]

    }

  }
}
