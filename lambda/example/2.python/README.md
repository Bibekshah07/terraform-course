# Creating a python lambda function with external library

It will give find ip-address in python.

Before you start make sure you already have your account configured for awscli and terraform installed.

* write your business logic for lambda function.

 it’s a script that uses the requests library to find out the public IP of the lambda function

# Tell python to include the package directory

```
# src/lambda_function.py

# Tell python to include the package directory
import sys
sys.path.insert(0, 'package/')

import requests

def lambda_handler(event, context):

    my_ip = requests.get("https://api.ipify.org?format=json").json()

    return {"Public Ip": my_ip["ip"]}

```

* create src/package direcory in which all external library will be installed.

```
mkdir src/package
```

* create requirements.txt for all external library information

```
# src/requirements.txt

# here requests is an external library for python
requests

```
* create build.sh

The build.sh is very simple yet effective, it navigates to the scripts directory and installs all requirements into the package directory.

```
# src/build.sh


#!/usr/bin/env bash

# Change to the script directory
cd "$(dirname "$0")"
pip install -r requirements.txt -t package/

```
* create variables.tf and Set the region where the lambda function will be created ( here default value is "us-east-1"

```
# variables.tf

# Set the region where the lambda function will be created
variable "aws_region" {
  default = "us-east-1"
}

```

* create main.tf as basic configuration file.

This step is a null resource, that executes the build.sh whenever one of the following files change (see the triggers-section): - lambda_function.py - requirements.txt - build.sh

```

# main.tf

# Assign the region to the provider in this case AWS
provider "aws" {
  region = "${var.aws_region}"
}

#This Step is a null resource, that executes the build.sh
resource "null_resource" "lambda_buildstep" {
  triggers = {
    handler      = "${base64sha256(file("src/lambda_function.py"))}"
    requirements = "${base64sha256(file("src/requirements.txt"))}"
    build        = "${base64sha256(file("src/build.sh"))}"
  }

  provisioner "local-exec" {
    command = "${path.module}/src/build.sh"
  }
}

# Archive the code or project that we want to run
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src/"
  output_path = "${path.module}/src/python_1_lambda_function.zip"

  depends_on = ["null_resource.lambda_buildstep"]
}


```

With the exception of the depends_on-clause. Here we’re waiting for the build step to finish, before we compress the results.

* create iam.tf ,IAM role for  Necessary permissions to create/run the function

```
# iam.tf

# Necessary permissions to create/run the function 
resource "aws_iam_role" "iam_for_lambda_tf" {
  name = "iam_for_lambda_tf_2_python"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


```

* create lambda.tf , for function confuguration 

```

#lambda.tf

# Create the function
resource "aws_lambda_function" "service" {
  function_name    = "python_2_lambda_function"
  role             = "${aws_iam_role.iam_for_lambda_tf.arn}"
  handler          = "lambda_function.lambda_handler"
  filename         = "${data.archive_file.lambda_zip.output_path}"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  runtime          = "python3.7"
  timeout          = 60
}

```

* create output.tf , for getting created lambdafunction arn and name

```
# output.tf

output "function_arn" {
  value = "${aws_lambda_function.service.arn}"
}

output "function_name" {
  value = "${aws_lambda_function.service.function_name}"
}

```

* Initialize terraform
First of all we will need to initialize terraform. this will download the necessary plugins that we used in the code, otherwise it won’t be able to run.

```
terraform init

```
* Apply the changes
The next step would be to apply the changes, this command will take care of doing everything that we defined, it will archive the code, the IAM role and the function itself.

```
terraform apply

```

* Running the function
Then the last step would be to run our function to see if it actually works, in this case we’re using the awscli but you can use the AWS console as well, the result will be the same.

```
aws lambda invoke --function-name python_2_lambda_function --invocation-type RequestResponse --log-type Tail - | jq '.LogResult' -r | base64 --decode

```

* Clean up
Remember to clean up before leaving.

```

terraform destroy
```
