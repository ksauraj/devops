# Create a Target Group
resource "aws_lb_target_group" "app_tg" {
  name     = "apps-target-group"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.app-vpc.id

  health_check {
    protocol = "TCP"
    port     = "80"
  }

  tags = {
    Name = "App-Target-Group"
  }
}

# Register Instances with the Target Group
resource "aws_lb_target_group_attachment" "instance_1_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.pvt-1-instance.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "instance_2_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.pvt-2-instance.id
  port             = 80
}

# Create the Network Load Balancer for our app
resource "aws_lb" "network_lb" {
  name               = "app-nlb"
  internal           = false 
  load_balancer_type = "network"
  subnets            = [aws_subnet.nlb-subnet.id, aws_subnet.pvt-2-subnet.id]

  enable_deletion_protection = false

  tags = {
    Name = "App-NLB"
  }
}

# Create a Listener for the NLB
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.network_lb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}