resource "aws_security_group" "alb_public" {
  name        = "sgrp-alb-${var.group}-${var.env}-pub"
  description = "control access to public alb"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "sg-alb-${var.group}-${var.env}-pub"
    Scope = "public"
  }
}

resource "aws_security_group" "alb_private" {
  name        = "sgrp-alb-${var.group}-${var.env}-prv"
  description = "control access to private alb"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "sg-alb-${var.group}-${var.env}-prv"
    Scope = "private"
  }
}


resource "aws_security_group" "ecs_tasks" {
  name   = "sgrp-ecs-tasks-${var.group}-${var.env}"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "sg-ecs-tasks-${var.group}-${var.env}"
  }
}
