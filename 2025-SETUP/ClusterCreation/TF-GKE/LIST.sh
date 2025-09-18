#!/usr/bin/env bash

set -x
gcloud container clusters list
#gcloud container clusters list --verbosity debug
gcloud compute network-endpoint-groups  list

