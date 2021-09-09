
resource "aws_route53_record" "server-record" {
  #zone_id = aws_route53_zone.testzone.zone_id
  zone_id = var.zone_id
  count   = 2
  name    = "server-${count.index}.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.eip[count.index].public_ip]
}

#resource "aws_route53_zone" "testzone" {
  #name = var.domain_name
  #comment = "${var.domain_name} public zone"
  #provider = aws
#}



