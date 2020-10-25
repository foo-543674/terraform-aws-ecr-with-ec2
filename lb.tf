resource "aws_lb" "test" {
  name               = "test"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.for_lb.id]
  subnets            = [aws_subnet.main.id]

  enable_deletion_protection = true
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.test.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_lb_listener_rule" "to_test" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }

  condition {
    host_header {
      values = ["*"]
    }
  }
}

resource "aws_lb_target_group" "test" {
  name     = "test"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}
