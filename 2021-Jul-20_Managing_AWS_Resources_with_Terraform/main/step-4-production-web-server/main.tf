
resource "aws_instance" "webserver" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.aws_instance_type

  key_name               = aws_key_pair.gen_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.extl-secgroup.id]

  tags = {
    Terraform = "True"
    Purpose   = "1st simple attempt at a web server"
  }

  # Better way: reference a file here:
  user_data = "${file("webserver_boot.sh")}"
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

  /* Optionally open ports for grafana / prometheus:
  ingress { # Grafana
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # Prometheus
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  */

  # Open egress port 443 to be able to perform "git clone":
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  /* Default egress rule disables all outgoing traffic for all protocols
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } */
}


