
variable website_name {
    description = "Website name"
    default     = "My first website"
}

variable website_url {
    description = "Website FQDN"
    default     = "https://acme.net"
}

variable start_web_server {
    description = "Commands to install/setup web server [must be blocking]"
    #type        = list(string)
    #default     = []
    default     = ""
}

