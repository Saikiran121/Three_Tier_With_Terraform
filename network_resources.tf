# Create a VPC
resource "aws_vpc" "three_tier_vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "three tier vpc"
  }
}

# Public Subnets
resource "aws_subnet" "three_tier_pub_sub_1" {
  vpc_id = aws_vpc.three_tier_vpc.id
  cidr_block = "10.0.0.0/28"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "three tier pub sub 1"
  }
}

resource "aws_subnet" "three_tier_pub_sub_2" {
  vpc_id = aws_vpc.three_tier_vpc.id
  cidr_block = "10.0.0.16/28"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "three tier pub sub 2"
  }
}

# Private Subnets
resource "aws_subnet" "three_tier_pvt_sub_1" {
  vpc_id = aws_vpc.three_tier_vpc.id
  cidr_block = "10.0.0.32/28"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "three tier pvt sub 1"
  } 
}

resource "aws_subnet" "three_tier_pvt_sub_2" {
  vpc_id = aws_vpc.three_tier_vpc.id
  cidr_block = "10.0.0.48/28"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "three tier pvt sub 2"
  } 
}

resource "aws_subnet" "three_tier_pvt_sub_3" {
  vpc_id = aws_vpc.three_tier_vpc.id
  cidr_block = "10.0.0.64/28"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "three tier pvt sub 3"
  } 
}

resource "aws_subnet" "three_tier_pvt_sub_4" {
  vpc_id = aws_vpc.three_tier_vpc.id
  cidr_block = "10.0.0.80/28"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "three tier pvt sub 4"
  } 
}

# Internet Gateway
resource "aws_internet_gateway" "three_tier_igw" {
  vpc_id = aws_vpc.three_tier_vpc.id

  tags = {
    Name = "three tier igw"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "three_tier_nat_eip" {
  vpc = true
}


# NAT Gateway
resource "aws_nat_gateway" "three_tier_natgw_01" {
  allocation_id = aws_eip.three_tier_nat_eip.id
  subnet_id = aws_subnet.three_tier_pub_sub_1.id
  depends_on = [ aws_internet_gateway.three_tier_igw ]

  tags = {
    Name = "three tier natgw 01"
  }
}

# Route Table
resource "aws_route_table" "three_tier_web_rt" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.three_tier_igw.id
  }

  tags = {
    Name = "three tier web rt"
  }
}

resource "aws_route_table" "three_tier_app_rt" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.three_tier_natgw_01.id
  }

  tags = {
    Name = "three tier app rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "three_tier_rt_as_1" {
  subnet_id = aws_subnet.three_tier_pub_sub_1.id
  route_table_id = aws_route_table.three_tier_web_rt.id
}

resource "aws_route_table_association" "three_tier_rt_as_2" {
  subnet_id = aws_subnet.three_tier_pub_sub_2.id
  route_table_id = aws_route_table.three_tier_web_rt.id
}

resource "aws_route_table_association" "three_tier_rt_as_3" {
  subnet_id = aws_subnet.three_tier_pvt_sub_1.id
  route_table_id = aws_route_table.three_tier_app_rt.id
}

resource "aws_route_table_association" "three_tier_rt_as_4" {
  subnet_id = aws_subnet.three_tier_pvt_sub_2.id
  route_table_id = aws_route_table.three_tier_app_rt.id
}

resource "aws_route_table_association" "three_tier_rt_as_5" {
  subnet_id = aws_subnet.three_tier_pvt_sub_3.id
  route_table_id = aws_route_table.three_tier_app_rt.id
}

resource "aws_route_table_association" "three_tier_rt_as_6" {
  subnet_id = aws_subnet.three_tier_pvt_sub_4.id
  route_table_id = aws_route_table.three_tier_app_rt.id
}

#Elastic IP for NAT Gateway
resource "aws_eip" "three_tier_nat_ip" {
  vpc = true
}




