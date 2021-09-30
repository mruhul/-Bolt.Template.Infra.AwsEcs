resource "aws_ecs_cluster" "main" {
  name               = "${var.group}-${var.env}-cluster"
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = "100"
  }

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "ecs-cluster-${var.group}-${var.env}"
  }
}
