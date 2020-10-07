resource "aws_ecs_task_definition" "nginx" {
  family = "nginx"
  container_definitions = templatefile("container_definition.json", {
    repository_url = aws_ecr_repository.nginx.repository_url
    log_group_name = aws_cloudwatch_log_group.nginx_log.name
  })
  task_role_arn      = aws_iam_role.task.arn
  execution_role_arn = aws_iam_role.task_execution.arn

  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
}
