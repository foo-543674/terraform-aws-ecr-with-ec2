resource "aws_ecs_service" "nginx" {
  name                               = "nginx"
  cluster                            = aws_ecs_cluster.test.id
  task_definition                    = aws_ecs_task_definition.nginx.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100

  load_balancer {
    target_group_arn = aws_lb_target_group.test.arn
    container_name   = "nginx"
    container_port   = 80
  }

  network_configuration {
    subnets         = [aws_subnet.main.id]
    security_groups = [aws_security_group.allows_http.id]
  }
}

resource "aws_appautoscaling_target" "ecs_service" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.test.name}/${aws_ecs_service.nginx.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}