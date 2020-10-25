locals {
  cluster_name = "test-cluster"
}

resource "aws_ecs_cluster" "test" {
  name = local.cluster_name

  capacity_providers = [aws_ecs_capacity_provider.test.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.test.name
    weight            = 1
    base              = 0
  }
}

resource "aws_ecs_capacity_provider" "test" {
  name = "ec2"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.test.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}