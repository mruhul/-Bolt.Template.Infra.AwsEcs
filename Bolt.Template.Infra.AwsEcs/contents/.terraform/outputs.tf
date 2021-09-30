output "alb_public_hostname" {
  value = aws_alb.public.dns_name
}

output "alb_public_id" {
  value = aws_alb.public.id
}
