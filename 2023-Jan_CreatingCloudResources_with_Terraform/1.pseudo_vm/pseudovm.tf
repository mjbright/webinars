
variable "ssh_port" {
  default = 2222
}

variable "web_port" {
  default = 8080
}

variable "ssh_user" {
  default = "student"
}

# Simulate a VM (using a Docker Container):
resource "docker_container" "pseudo_vm_web" {
  image   = "lscr.io/linuxserver/openssh-server:latest"
  name    = "pseudo-vm"
  restart = "unless-stopped"

  ports {
    internal = 2222
    external = var.ssh_port
  }
  
  ports {
    internal = 80
    external = var.web_port
  }
  
  env = [ "PUID=1000", "PGID=1000", "TZ=Europe/London",
          "USER_NAME=${ var.ssh_user }",
          "PUBLIC_KEY=${ data.tls_public_key.private_key_pem-example.public_key_openssh }",
          "SUDO_ACCESS=true",
          
          # NOTE: we allow password access in case we need to debug
          # DISABLED to allow password-less sudo access:
          # "PASSWORD_ACCESS=true", "USER_PASSWORD=pass"
         ]

  connection {
    type        = "ssh"
    host        = "127.0.0.1"
    port        = var.ssh_port
    user        = var.ssh_user
    private_key = tls_private_key.pseudo-vm-sshkey.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [ "mkdir site" ]
  }

  # command = [ "apk add nginx", "sleep 3600" ]
  provisioner "file" {
    #source       = "site/index.html"
    #destination  = "/var/www/localhost/htdocs/index.html"
    source       = "site/"
    destination  = "site/"
  }

  # Need remote-exec:
  provisioner "remote-exec" {
      inline = [ var.start_web_server ]
  }
}

# Create a TLS private key  resource
resource "tls_private_key" "pseudo-vm-sshkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "tls_public_key" "private_key_pem-example" {
  private_key_pem = tls_private_key.pseudo-vm-sshkey.private_key_pem
}

resource "local_file" "pseudo-vm-sshkey-file" {
  filename        = "key.pem"
  content         = tls_private_key.pseudo-vm-sshkey.private_key_pem
  file_permission = 0600
}

output  "ssh_rsa_pub_key" { value = tls_private_key.pseudo-vm-sshkey.public_key_openssh }

# NOTE: we mark this element as sensitive information,
#       to be able to output the value
output  "ssh_pem_key"     {
  value = tls_private_key.pseudo-vm-sshkey.private_key_pem
  sensitive = true
}

