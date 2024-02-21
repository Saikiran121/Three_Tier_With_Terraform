# Load balancer security group - 1
resource "aws_security_group" "three_tier_alb_sg_1" {
  name        = "three_tier_alb_sg_1"
  description = "load balancer security group for web tier"
  vpc_id      = aws_vpc.three_tier_vpc.id
  depends_on = [
    aws_vpc.three_tier_vpc
  ]


  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "three_tier_alb_sg_1"
  }
}

# Load balancer security group - 2 - app
resource "aws_security_group" "three_tier_alb_sg_2" {
  name        = "three_tier_alb_sg_2"
  description = "load balancer security group for app tier"
  vpc_id      = aws_vpc.three_tier_vpc.id
  depends_on = [
    aws_vpc.three_tier_vpc
  ]

  ingress {
    from_port          = "80"
    to_port            = "80"
    protocol           = "tcp"
    security_groups    = [aws_security_group.three_tier_alb_sg_1.id]
  }

  tags = {
    Name = "three_tier_alb_sg_2"
  }
}
#################################################################################################################################################

# web tier auto scalling group - Security Group
resource "aws_security_group" "three_tier_ec2_asg_sg" {
  name        = "three_tier_ec2_asg_sg"
  description = "Allow traffic from VPC"
  vpc_id      = aws_vpc.three_tier_vpc.id
  depends_on = [
    aws_vpc.three_tier_vpc
  ]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
  }
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "three_tier_ec2_asg_sg"
  }
}

# app tier auto scalling group - Security Group
resource "aws_security_group" "three_tier_ec2_asg_sg_app" {
  name        = "three_tier_ec2_asg_sg_app"
  description = "Allow traffic from web tier"
  vpc_id      = aws_vpc.three_tier_vpc.id
  depends_on = [
    aws_vpc.three_tier_vpc
  ]

  ingress {
    from_port = "-1"
    to_port   = "-1"
    protocol  = "icmp"
    security_groups  = [aws_security_group.three_tier_ec2_asg_sg.id]
  }
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    security_groups  = [aws_security_group.three_tier_ec2_asg_sg.id]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    security_groups  = [aws_security_group.three_tier_ec2_asg_sg.id]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "three_tier_ec2_asg_sg_app"
  }
}

#####################################################################################################################

# Database tier Security gruop
resource "aws_security_group" "three_tier_db_sg" {
  name        = "three_tier_db_sg"
  description = "allow traffic from app tier"
  vpc_id      = aws_vpc.three_tier_vpc.id

  #ingress {
    #from_port       = 3306
    #to_port         = 3306
    #protocol        = "tcp"
    #security_groups = [aws_security_group.three-tier-ec2-asg-sg-app.id]
    #cidr_blocks     = ["0.0.0.0/0"]
  #}


  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.32/28" , "10.0.0.48/28"]
    description      = "Access for the web ALB SG"
    #security_groups = [aws_security_group.prlw-webalb-sg.id]
  }


  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.three_tier_ec2_asg_sg_app.id]
    cidr_blocks     = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

