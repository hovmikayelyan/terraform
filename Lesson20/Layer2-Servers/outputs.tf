
output "webserver_sg_id" {
  value = aws_security_group.my_webserver.id
}


output "webserver_public_ip" {
  value = aws_instance.web_server.public_ip
}