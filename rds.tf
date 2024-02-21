# RDS
resource "aws_db_subnet_group" "three_tier_db_sub_grp" {
  name = "three-tier-db-sub-grp"
  subnet_ids = ["${aws_subnet.three_tier_pvt_sub_3.id}","${aws_subnet.three_tier_pvt_sub_4.id}"]
}

resource "aws_db_instance" "three_tier_db" {
  allocated_storage = 100
  storage_type = "gp3"
  db_name = "mydb"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t2.micro"
  identifier = "three-tier-db"
  username = "admin"
  password = "805057Sai"
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.three_tier_db_sub_grp.name
  vpc_security_group_ids = ["${aws_security_group.three_tier_db_sg.id}"]
  multi_az = true 
  skip_final_snapshot = true 
  publicly_accessible = false 

  lifecycle {
    prevent_destroy = false
    ignore_changes = all
  }
}
