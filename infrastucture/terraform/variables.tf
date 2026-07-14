variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "bankops"
}

variable "eks_cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "bankops-cluster"
}

variable "db_name" {
  description = "Database Name"
  type        = string
  default     = "bankdb"
}

variable "db_username" {
  description = "Database Username"
  type        = string
  default     = "bank_app"
}

variable "db_password" {
  description = "Database Password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS Instance Type"
  type        = string
  default     = "db.t3.micro"
}
