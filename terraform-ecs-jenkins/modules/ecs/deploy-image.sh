#!/bin/bash

region=$1
image_name=$2
repository_url=`echo $3 | sed 's~http[s]*://~~g'`

aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${repository_url}
  docker build -t ${image_name} .
  docker tag ${image_name}:latest ${repository_url}:latest
  docker push ${repository_url}:latest
