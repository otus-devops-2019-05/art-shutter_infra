#!/bin/bash

gcloud compute instances create reddit-app \
--image-family reddit-full \
--machine-type=g1-small \
--restart-on-failure
