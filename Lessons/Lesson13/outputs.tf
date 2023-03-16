output "latest_amzn_linux_id" {
  value = data.aws_ami.latest_amznLinux.id
}
output "latest_amzn_linux_name" {
  value = data.aws_ami.latest_amznLinux.name
}
