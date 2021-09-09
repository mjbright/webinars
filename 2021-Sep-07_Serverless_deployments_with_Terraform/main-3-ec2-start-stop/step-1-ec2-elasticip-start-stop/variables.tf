
variable "region" {
  default = "us-west-1"
}

variable "aws_instance_type" {
  default = "t2.micro"
}

# Info about this image here: https://cloud-images.ubuntu.com/query/bionic/server/released.txt
#    bionic server  release 20190116  ebs-ssd amd64 us-west-1 ami-0e81aa4c57820bb57     hvm
# https://help.ubuntu.com/community/UEC/Images
variable "aws_ami" {
    # us-west-1 Ubuntu18.04 instance
    #default = "ami-0e81aa4c57820bb57"
    default = "ami-06d3d567417463f25" # NEW 16G image, bionic 18.04.LTS
}

# Provide different key name as we want this to persist
variable "key_pair_name" {
    type = string
    default = "persist_key_start_stop"
}

variable "key_file" {
    type = string
    default = "persist_key.pem"
}

variable "webserver_port" {
  default = "80"
}

# Route53 variables:

# Note: you must own the domain:
variable "domain_name" {
  default = "subdomain.mjbright.click"
}

# Note: put the AWS managed zone_id here:
variable zone_id {
    default = "/hostedzone/Z0467846EF4MXRFCUZ9N"
}


