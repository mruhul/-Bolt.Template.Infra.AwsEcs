resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids   = aws_route_table.private.*.id
  vpc_endpoint_type = "Gateway"

  policy = <<POLICY
{
    "Statement": [
        {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*"
        }
    ]
}
POLICY

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "endpoint-s3-${var.group}-${var.env}"
  }
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id          = aws_vpc.main.id
  service_name    = "com.amazonaws.${var.aws_region}.dynamodb"
  route_table_ids = aws_route_table.private.*.id

  policy = <<POLICY
{
    "Statement": [
        {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*"
        }
    ]
}
POLICY

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "endpoint-dynamodb-${var.group}-${var.env}"
  }
}
