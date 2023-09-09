module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name         = "${var.application_name}-ecr"
  repository_type         = "private"
  repository_force_delete = true

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 2 images",
        selection = {
          tagStatus   = "any",
          countType   = "imageCountMoreThan",
          countNumber = 2
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}
