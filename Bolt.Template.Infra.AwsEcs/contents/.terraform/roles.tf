data "aws_iam_policy_document" "ecs_task_execution_policy" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "ecs_service" {
  name               = "role-ecs-service-${var.group}-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_policy.json

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "role-ecs-service-${var.group}-${var.env}"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_atttachement" {
  role       = aws_iam_role.ecs_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
