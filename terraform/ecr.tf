# ---------- Registres d'images ----------
resource "aws_ecr_repository" "backend" {
  name         = "${var.project}-backend"
  force_delete = true
  image_scanning_configuration { scan_on_push = true }
}

resource "aws_ecr_repository" "frontend" {
  name         = "${var.project}-frontend"
  force_delete = true
  image_scanning_configuration { scan_on_push = true }
}

resource "aws_ecr_lifecycle_policy" "keep_last_10" {
  for_each   = { backend = aws_ecr_repository.backend.name, frontend = aws_ecr_repository.frontend.name }
  repository = each.value
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Garder les 10 dernieres images"
      selection    = { tagStatus = "any", countType = "imageCountMoreThan", countNumber = 10 }
      action       = { type = "expire" }
    }]
  })
}
