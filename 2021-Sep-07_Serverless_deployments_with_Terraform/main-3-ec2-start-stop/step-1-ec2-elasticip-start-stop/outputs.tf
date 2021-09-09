
output "elastic_ips" {
  value = [aws_eip.eip.*.public_ip]
}

output "public_ips" {
  value = [aws_instance.server.*.public_ip]
}

output "ip-urls" {
  value = [formatlist("http://%s:%s", aws_instance.server.*.public_ip, var.webserver_port)]
}

output "host-urls" {
  value = [formatlist("http://%s:%s", aws_route53_record.server-record.*.name, var.webserver_port)]
}

output "hosts" {
  value = [formatlist("%s", aws_route53_record.server-record.*.name)]
}


