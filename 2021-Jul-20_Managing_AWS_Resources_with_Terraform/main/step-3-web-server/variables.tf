
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

variable "key_pair_name" {
    type = string
    default = "my_aws_key"
}

variable "key_file" {
    type = string
    default = "my_aws_key.pem"
}

variable "webserver_port" {
  default = "80"
}


