
# Derived from
- https://github.com/murphye/cheap-gke-cluster

# Standing up cluster

First login using:
     gcloud_login.sh

Then
    terraform init
    terraform apply # May take a looooong time (25+ minutes!)

In the meantime:
    gcloud auth login
    gcloud container clusters list

    NAME         LOCATION    MASTER_VERSION      MASTER_IP      MACHINE_TYPE   NODE_VERSION        NUM_NODES  STATUS
    gke-cluster  us-west4-a  1.32.4-gke.1353003  34.16.158.151  e2-standard-2  1.32.4-gke.1353003  1          PROVISIONING

## About long startup time: (but not helpful when using Terraform):
https://stackoverflow.com/questions/53853278/over-15-minutes-and-counting-startup-time-for-a-demo-kubernetes-cluster

## gcloud container clusters list options:

gcloud container clusters list -h
gcloud container clusters list --help
gcloud container clusters list --verbosity info
gcloud container clusters list --verbosity none
gcloud container clusters list --verbosity debug


