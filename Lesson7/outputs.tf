output "webserver_instance_id" {
  value = aws_instance.my_webserver.id
}

output "owner_id" {
  value = aws_security_group.my_webserver.owner_id
}

output "vpc_security_group_ids" {
  value = aws_security_group.my_webserver.vpc_id
  description = "vpc-id"
}