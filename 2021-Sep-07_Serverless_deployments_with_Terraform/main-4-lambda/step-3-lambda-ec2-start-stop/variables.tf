
variable "region" {
  default = "us-west-1"
}

# tbd: variable runtime { default = "python3.8" }

variable functions {
  type = list(map(string))

  description = "name AWS Lambda will assign to these functions"

  default = [
    { runtime: "python3.8", name: "ec2_describe_all" }, 
    { runtime: "python3.8", name: "ec2_stop" },
    { runtime: "python3.8", name: "ec2_start" },
  ]
}

variable "zip_file" {
  default = "lambda.zip"
}

#tbd:
#variable "domain_name" { type        = string description = "The domain name for the website." }
#variable "zone" { description = "DNS zone id" }



