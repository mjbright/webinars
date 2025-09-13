# Project Terraform:

# Replace with your 'terraform' project id:
project_id  = "terraform-419313"

# Pick a region with low spot VM prices. us-west4 is currently the cheapest. asia-east2 and southamerica-east1 are also cheap options.
# https://cloud.google.com/compute/vm-instance-pricing
#

# Now set by environment variables in setup.rc:
# region           = "us-west4"
# zone             = "us-west4-a"

gke_cluster_name = "gke-cluster"
num_nodes        = 1
machine_type     = "e2-standard-2"
disk_size        = 20
network_name     = "my-network"
ip_address_name  = "my-static-ip"
ssl_cert_name    = "my-ssl-cert"
ssl_cert_crt     = "certs/self-signed.crt"
ssl_cert_key     = "certs/self-signed.key"

# Change to true to enable HTTPS and HTTP redirect for the load balancer
https            = false
