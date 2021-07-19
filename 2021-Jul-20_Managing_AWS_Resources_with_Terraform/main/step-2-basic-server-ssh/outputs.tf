
output "public_ips" {
  value = [aws_instance.webserver.*.public_ip]
}


