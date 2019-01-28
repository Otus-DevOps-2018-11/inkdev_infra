#/bin/bash

gcloud compute instances create reddit-full\
  --image "reddit-full-1548324659" \
  --machine-type=f1-micro \
  --zone=europe-west1-b \
  --restart-on-failure \
