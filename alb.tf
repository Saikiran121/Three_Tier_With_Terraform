# Load Balancer for Web Tier
resource "aws_lb" "three_tier_web_lb" {
  name = "three-tier-web-lb"
  internal = true 
  load_balancer_type = "application"

  security_groups = [aws_security_group.three_tier_alb_sg_1.id]
  subnets = [aws_subnet.three_tier_pub_sub_1.id, aws_subnet.three_tier_pub_sub_2.id]

  tags = {
    Environment = "three_tier_web_lb"
  }
}

# Load Balancer for App Tier
resource "aws_lb" "three_tier_app_lb" {
  name = "three-tier-app-lb"
  internal = true 
  load_balancer_type = "application"

  security_groups = [aws_security_group.three_tier_alb_sg_2.id]
  subnets = [aws_subnet.three_tier_pvt_sub_1.id, aws_subnet.three_tier_pvt_sub_2.id]

  tags = {
    Environment = "three_tier_app_lb"
  }
}

# Load Balancer Target Group - Web Tier
resource "aws_lb_target_group" "three_tier_web_lb_tg" {
  name = "three-tier-web-lb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.three_tier_vpc.id

  health_check {
    interval = 30
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 10
    healthy_threshold = 3 
    unhealthy_threshold = 3 
  }
}

# Load Balancer Target Group - App Tier
resource "aws_lb_target_group" "three_tier_app_lb_tg" {
  name = "three-tier-app-lb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.three_tier_vpc.id

  health_check {
    interval = 30
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 10
    healthy_threshold = 3 
    unhealthy_threshold = 3 
  }
}


# Load Balancer Listener - Web Tier
resource "aws_lb_listener" "three_tier_web_lb_listener" {
  load_balancer_arn = aws_lb.three_tier_web_lb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.three_tier_web_lb_tg.arn
  }
}

# Load Balancer Listener - App Tier
resource "aws_lb_listener" "three_tier_app_lb_listener" {
  load_balancer_arn = aws_lb.three_tier_app_lb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.three_tier_app_lb_tg.arn
  }
}

# Register the instance with Target Group - Web Tier
resource "aws_autoscaling_attachment" "three_tier_web_asattach" {
  autoscaling_group_name = aws_autoscaling_group.three_tier_web_asg.name
  lb_target_group_arn = aws_lb_target_group.three_tier_web_lb_tg.arn
}

# Register the instance with Target Group - App Tier
resource "aws_autoscaling_attachment" "three_tier_app_asattach" {
  autoscaling_group_name = aws_autoscaling_group.three_tier_app_asg.name
  lb_target_group_arn = aws_lb_target_group.three_tier_app_lb_tg.arn
}


