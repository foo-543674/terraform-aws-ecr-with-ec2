resource "aws_autoscaling_group" "test" {
  name = "test"

  launch_template {
    id      = aws_launch_template.test.id
    version = "$Latest"
  }

  protect_from_scale_in = true
  max_size              = 1
  min_size              = 1
}

resource "aws_launch_template" "test" {
  name          = "test"
  image_id      = data.aws_ssm_parameter.amzn2_for_ecs_ami.value
  instance_type = "t2.micro"
  ebs_optimized = true
  user_data = base64encode(templatefile("./userdata.sh",
    {
      cluster_name = local.cluster_name
  }))

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 40
      volume_type = "gp2"
    }
  }
}

data "aws_ssm_parameter" "amzn2_for_ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}