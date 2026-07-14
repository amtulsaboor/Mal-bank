resource "aws_secretsmanager_secret" "bank_secret" {

  name = "${var.project_name}/database"


  description = "BankOps database credentials"


  tags = {

    Name = "${var.project_name}-db-secret"

  }

}


resource "aws_secretsmanager_secret_version" "bank_secret_value" {

  secret_id = aws_secretsmanager_secret.bank_secret.id


  secret_string = jsonencode({

    username = var.db_username

    database = var.db_name

  })

}
