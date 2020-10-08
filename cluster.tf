locals {
  cluster_name = "test-cluster"
}

resource "aws_ecs_cluster" "test" {
  name = local.cluster_name

  capacity_providers = [aws_ecs_capacity_provider.test.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.test.name
    weight = 1
    base = 1
  }
}