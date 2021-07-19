
resource "aws_instance" "webserver" {
  ami           = var.aws_ami
  instance_type = var.aws_instance_type

  key_name               = aws_key_pair.gen_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.extl-secgroup.id]

  tags = {
    Terraform = "True"
    Purpose   = "1st simple attempt at a web server"
  }

  # user_data can be accessed thus, from within the instance:
  #     curl -sL http://169.254.169.254/latest/user-data
  # user_data can be deleted thus, from outside the instance:
  #     aws ec2 modify-instance-attribute --instance-id <your-instance-id> --user-data ":"
  user_data = <<-EOF
    #!/bin/bash

    echo "<html ><head><title>Server is UP</title></head>  <body><h1>Welcome - Server is UP</h1></body> </html>" > index.html
    nohup busybox httpd -f -p "${var.webserver_port}" &
EOF

}

# Automatically generated key 'gen_tls_pk':
resource "tls_private_key" "gen_tls_pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Automatically generated key_pair 'gen_key_pair':
resource "aws_key_pair" "gen_key_pair" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.gen_tls_pk.public_key_openssh
}

# File to save .pem key to:
resource "local_file" "key_local_file" {
    content     = tls_private_key.gen_tls_pk.private_key_pem
    filename    = var.key_file
}

resource "aws_security_group" "extl-secgroup" {
  name  = "extl-secgroup"

  # Enable ssh external server connection:
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Enable web server server connection:
  ingress {
    from_port   = var.webserver_port
    to_port     = var.webserver_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


