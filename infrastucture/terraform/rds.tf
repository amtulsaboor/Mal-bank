resource "aws_db_instance" "bank_database" {

  identifier = "${var.project_name}-postgres"


  engine = "postgres"


  engine_version = "16"


  instance_class = var.db_instance_class


  allocated_storage = 20


  username = var.db_username


  password = var.db_password


  db_name = var.db_name


  publicly_accessible = false


  storage_encrypted = true


  backup_retention_period = 7


  skip_final_snapshot = true


  tags = {

    Name = "${var.project_name}-rds"

  }

}
