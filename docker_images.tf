data "aws_caller_identity" "current" {}

resource "null_resource" "docker_packaging" {

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.ecr_repo.repository_url} && docker build -t ${aws_ecr_repository.ecr_repo.name} . && docker tag ${aws_ecr_repository.ecr_repo.name}:latest ${aws_ecr_repository.ecr_repo.repository_url}:latest && docker push ${aws_ecr_repository.ecr_repo.repository_url}:latest"
  }

  triggers = {
    "src_hash" = join("", [for f in fileset("src", "**") : filemd5("src/${f}")])
  }

  depends_on = [
    aws_ecr_repository.ecr_repo,
  ]
}
