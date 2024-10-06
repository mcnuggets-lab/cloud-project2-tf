# create ecr repo
resource "aws_ecr_repository" "ecr_repo" {
  name = var.project_name
}

resource "aws_ecr_lifecycle_policy" "default_policy" {
  repository = aws_ecr_repository.ecr_repo.name

  policy = <<EOF
	{
	    "rules": [
	        {
	            "rulePriority": 1,
	            "description": "Keep only 1 untagged images.",
	            "selection": {
	                "tagStatus": "untagged",
	                "countType": "imageCountMoreThan",
	                "countNumber": 1
	            },
	            "action": {
	                "type": "expire"
	            }
	        }
	    ]
	}
	EOF
}

data "aws_ecr_image" "docker_image" {
  repository_name = aws_ecr_repository.ecr_repo.name
  image_tag       = "latest"

  depends_on = [null_resource.docker_packaging]
}
