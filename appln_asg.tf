# Import existing EC2 Key Pair
data "aws_key_pair" "three_tier_app_key_pair" {
  key_name = "three-tier-app-asg-kp"
}


# Launch configuration for EC2
resource "aws_launch_configuration" "three_tier_app_lconfig" {
  name_prefix = "three_tier_app_lconfig"
  image_id = "ami-03f4878755434977f"
  instance_type = "t2.micro"
  key_name = data.aws_key_pair.three_tier_app_key_pair.key_name
  security_groups = [aws_security_group.three_tier_ec2_asg_sg_app.id]
  user_data = <<-EOF
                #!/bin/bash

                sudo yum install mysql -y

                EOF
  associate_public_ip_address = false
    lifecycle {
      prevent_destroy = false
      ignore_changes = all 
    }
}


# EC2 Auto Scaling Group - Application Tier
resource "aws_autoscaling_group" "three_tier_app_asg" {
  name = "three_tier_app_asg"
  launch_configuration = aws_launch_configuration.three_tier_app_lconfig.id
  vpc_zone_identifier = [aws_subnet.three_tier_pvt_sub_1.id, aws_subnet.three_tier_pvt_sub_2.id]
  min_size = 2
  max_size = 3 
  desired_capacity = 2 

}
