provider "aws" {
  region = "us-east-1" // substitua pela região desejada
}

resource "aws_lambda_function" "minha_funcao_lambda" {
  function_name = "minha-funcao-lambda" // substituir pelo nosso nome da funcao 
  handler       = "index.handler"
  runtime       = "nodejs14.x" // substituir pelo runtime desejado
  timeout       = 60 // tempo limite em segundos
  memory_size   = 128 // tamanho da memória em MB

  // Código da função
  filename      = "caminho/para/o/arquivo.zip" // mudar para o nosso caminho
  source_code_hash = filebase64sha256("caminho/para/o/arquivo.zip")

  // Permissões para invocar a função
  role = aws_iam_role.lambda_exec_role.arn
}

// Definição da role (permissões) para a função Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

// Permissões para escrever logs no CloudWatch
resource "aws_iam_policy" "lambda_logs_policy" {
  name = "lambda-logs-policy"
  description = "Policy for writing Lambda logs to CloudWatch"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

// Anexa a política de logs à role da função Lambda
resource "aws_iam_role_policy_attachment" "lambda_logs_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_logs_policy.arn
}
