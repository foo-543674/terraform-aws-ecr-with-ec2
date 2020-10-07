resource "aws_iam_role" "task" {
  name               = "task"
  assume_role_policy = file("ecs_tasks_assume_role_policy.json")
}

resource "aws_iam_role" "task_execution" {
  name               = "task_execution"
  assume_role_policy = file("ecs_tasks_assume_role_policy.json")
}

resource "aws_iam_service_linked_role" "ecs" {
  aws_service_name = "ecs.amazonaws.com"
}

resource "aws_iam_role_policy" "task" {
  name = "ecs_task"
  role = aws_iam_role.task.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*",
        "logs:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
  EOF
}

data "aws_iam_policy" "task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "task_execution" {
  role       = aws_iam_role.task_execution.name
  policy_arn = data.aws_iam_policy.task_execution.arn
}
