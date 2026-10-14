output "app_url" {
  value = "http://${aws_lb.main.dns_name}"
}

output "ecr_backend_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "ecr_frontend_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "ecs_cluster" {
  value = aws_ecs_cluster.main.name
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.address
}

output "grafana_url" {
  value = "http://${aws_lb.grafana.dns_name}"
}
