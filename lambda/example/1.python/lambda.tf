# Create the function
resource "aws_lambda_function" "service" {
  function_name    = "python_1_lambda_function"
  role             = "${aws_iam_role.iam_for_lambda_tf.arn}"
  handler          = "lambda_function.lambda_handler"
  filename         = "${data.archive_file.lambda_zip.output_path}"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  runtime          = "python3.7"
  timeout          = 60
}
