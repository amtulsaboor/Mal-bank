resource "aws_eks_cluster" "bank_cluster" {

  name = var.eks_cluster_name

  role_arn = aws_iam_role.eks_cluster_role.arn

  version = "1.30"


  vpc_config {

    subnet_ids = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id
    ]

  }


  depends_on = [

    aws_iam_role_policy_attachment.eks_cluster_policy

  ]


  tags = {

    Name = var.eks_cluster_name

  }

}


resource "aws_eks_node_group" "bank_nodes" {

  cluster_name = aws_eks_cluster.bank_cluster.name

  node_group_name = "bank-workers"

  node_role_arn = aws_iam_role.eks_node_role.arn


  subnet_ids = [

    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id

  ]


  scaling_config {

    desired_size = 2

    max_size = 3

    min_size = 1

  }


  instance_types = [

    "t3.medium"

  ]


  depends_on = [

    aws_iam_role_policy_attachment.eks_worker_policy

  ]

}
