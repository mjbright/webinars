
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
# https://stackoverflow.com/questions/72849502/terraform-returns-invalid-grant-for-gcp-when-attempting-to-create-load-balance

MYPROJECT=terraform

gcloud auth application-default login

gcloud config set project $MYPROJECT

