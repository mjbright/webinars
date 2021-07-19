
output "public_ips" {
  value = [aws_instance.webserver.*.public_ip]
}

output "urls" {
  value = [formatlist("http://%s:%s", aws_instance.webserver.*.public_ip, var.webserver_port)]
}


