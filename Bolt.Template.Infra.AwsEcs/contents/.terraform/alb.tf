resource "aws_alb" "public" {
  name               = "alb-${var.group}-${var.env}-pub"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.alb_public.id]

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "alb-${var.group}-${var.env}-pub"
    Scope = "public"
  }
}

resource "aws_alb_listener" "public" {
  load_balancer_arn = aws_alb.public.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "you have reached default public alb response"
      status_code  = 200
    }
  }

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "alb-listener-${var.group}-${var.env}-pub"
    Scope = "public"
  }
}


resource "aws_alb" "private" {
  name            = "alb-${var.group}-${var.env}-prv"
  internal        = true
  subnets         = aws_subnet.private.*.id
  security_groups = [aws_security_group.alb_private.id]

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "alb-${var.group}-${var.env}-prv"
    Scope = "private"
  }
}


resource "aws_alb_listener" "private" {
  load_balancer_arn = aws_alb.private.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "you have reached private alb response"
      status_code  = 200
    }
  }

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "alb-listener-${var.group}-${var.env}-prv"
    Scope = "private"
  }
}
