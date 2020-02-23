# Creating a nodejs lambda function

It will be a simple hello world in node.js.

Before you start make sure you already have your account configured for awscli and terraform installed.

* write your business logic for lambda function.

```
# src/index.js

// 'Hello World' nodejs10.x runtime AWS Lambda function

exports.handler = (event, context, callback) => {
    console.log('Hello world!');
    callback(null, 'It works!');
}

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

```

# main.tf

# Assign the region to the provider in this case AWS
provider "aws" {
  region          = "${var.aws_region}"
}

# Archive the code or project that we want to run
data "archive_file" "lambda_zip" {
    type          = "zip"
    source_file   = "src/index.js"
    output_path   = "lambda_function.zip"
}

```

* create iam.tf ,IAM role for  Necessary permissions to create/run the function

```
# iam.tf

# Necessary permissions to create/run the function 
resource "aws_iam_role" "iam_for_lambda_tf" {
  name = "iam_for_lambda_tf"

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
resource "aws_lambda_function" "test_lambda" {
  filename         = "lambda_function.zip"
  function_name    = "test_lambda"
  role             = "${aws_iam_role.iam_for_lambda_tf.arn}"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  runtime          = "nodejs8.10"
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
