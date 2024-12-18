data "aws_iam_policy_document" "assume_role"{
    statement {
      effect = "Allow"

      principals {
        type = "Service"
        identifiers = [ "lambda.amazonaws.com" ]
      }

      actions = ["sts:AssumeRole"]
    }
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "lambda-user"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_lambda_function" "app_lambda_function"{
  filename = "my_lambda_function.zip"
  function_name = "lambda_handler"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "my_lambda_function.lambda_handler"

  source_code_hash = filebase64sha256("my_lambda_function.zip")

  runtime = "python3.13"
}


resource "null_resource" "install_dependencies" {
  provisioner "local-exec" {
    command = "pip install -r lambda/requirements.txt -t lambda/"
  }
 
  triggers = {
    dependencies_versions = filemd5("lambda/requirements.txt")
    source_versions = filemd5("my_lambda_function/my_lambda_function.py")
  }
}