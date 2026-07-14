locals {

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

}

resource "random_id" "suffix" {
  byte_length = 2
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "bank_vpc" {

  cidr_block           = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-vpc"
    }
  )
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.bank_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-igw"
    }
  )
}
