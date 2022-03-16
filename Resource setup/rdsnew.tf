# Create Database Subnet Group

# terraform aws db subnet group

resource "aws_db_subnet_group" "database-subnet-group" {

  name         = "database subnets"

  subnet_ids   = [aws_subnet.private-subnet-3.id, aws_subnet.private-subnet-4.id]

  description  = "Subnets for Database Instance"



  tags   = {

    Name = "Database Subnets"

  }

}



# Get the Latest DB Snapshot

# terraform aws data db snapshot

data "aws_db_snapshot" "latest-db-snapshot" {

  db_snapshot_identifier = "${var.database-snapshot-identifier}"

  most_recent            = true

  snapshot_type          = "manual"

}



# Create Database Instance Restored from DB Snapshots

# terraform aws db instance

resource "aws_db_instance" "database-instance" {

  instance_class          = "${var.database-instance-class}"

  skip_final_snapshot     = true

  availability_zone       = "us-east-1a"

  identifier              = "${var.database-instance-identifier}"

  snapshot_identifier     = data.aws_db_snapshot.latest-db-snapshot.id

  db_subnet_group_name    = aws_db_subnet_group.database-subnet-group.name

  multi_az                = "${var.multi-az-deployment}"

  vpc_security_group_ids  = [aws_security_group.database-security-group.id]

}



#Create New Database Instance



resource "aws_db_instance" "mysql" {

    identifier                = "mysql"

    allocated_storage         = 5

    backup_retention_period   = 2

    backup_window             = "01:00-01:30"

    maintenance_window        = "sun:00:00-sun:00:30"

    multi_az                  = true

    engine                    = "mysql"

    engine_version            = "8.0.27"

    instance_class            = "db.t2.micro"

    name                      = "worker_db"

    username                  = "worker"

    password                  = "worker"

    port                      = "3306"

    db_subnet_group_name      = aws_db_subnet_group.database-subnet-group.name

    vpc_security_group_ids    = [aws_security_group.database-security-group.id]

    skip_final_snapshot       = true

    final_snapshot_identifier = "worker-final"

    publicly_accessible       = true

}