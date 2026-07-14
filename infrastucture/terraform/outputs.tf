output "ecr_repository_url" {

  value = aws_ecr_repository.bank_api.repository_url

}


output "eks_cluster_name" {

  value = aws_eks_cluster.bank_cluster.name

}


output "rds_endpoint" {

  value = aws_db_instance.bank_database.endpoint

}


output "secret_name" {

  value = aws_secretsmanager_secret.bank_secret.name

}
