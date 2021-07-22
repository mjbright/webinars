
# Managing AWS Resources with Terraform

This folder contains the resources - slides & scripts - used when delivering the 20th july 2021 webinar for Ardan Labs.

This is a snapshot of those resources and will likely be followed up by a future blog post and further scenarios

## Contents

The demos were run as a series of steps run from the main directory

- step-1-basic-server
- step-2-basic-server-ssh
- step-3-web-server
- step-4-production-web-server
- step-5-s3-object-storage

To reproduce the demo sequence you should preserve the ```terraform.tfstate``` files, so

## Reproducing the demo steps

In directory main:
- Remove any *.tf, *.md or *.sh files which may be present
- Copy those files from the appropriate step subdirectory to main
- If necessary perform ```terraform init```
- perform ```terraform plan``` to see what changes would be made
- once confident proceed to a ```terraform apply```, and accept the proposed changes

### Demo steps

- step-1-basic-server:
  - Terraform creates an (EC2 VM) aws_instance
  - but we cannot connect to the instance
- step-2-basic-server-ssh:
  - Terraform creates ephemeral ssh keys/aws_key_pair
  - Terraform creates a security group which opens port 22
  - we can now ssh to the instance using ```ssh -i my_aws_key.pem ubuntu@PUBLIC_IP```
- step-3-web-server
  - We use ```user_data``` to sepecify code to be run at VM startup
  - The user_data installs an extremely simple web server
  - We open port 80 in the security group
  - we can now access to the web server on it's public_ip
- step-4-production-web-server
  - we refer to a script for the user_data
  - the script installs a more complete web site (still simple)
  - the script also installs Prometheus, Prometheus-node-exporter and Grafana allowing us to inspect node metrics
- step-5-s3-object-storage
  - Terraform creates an S3 bucket and an SQS queue
  - we can see S3 events in the SQS queue


