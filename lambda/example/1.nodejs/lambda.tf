# Create the function
resource "aws_lambda_function" "service" {
  filename         = "lambda_function.zip"
  function_name    = "nodejs_1"
  role             = "${aws_iam_role.iam_for_lambda_tf.arn}"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  runtime          = "nodejs10.x"
}
