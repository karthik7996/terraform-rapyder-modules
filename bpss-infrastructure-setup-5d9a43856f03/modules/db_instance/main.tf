resource "aws_db_instance" "db_instance" {
  allocated_storage      = var.allocated_storage
  db_name                = endswith(var.name,"read-repica-db") == true ? null : var.db_name #var.db_name
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = endswith(var.name,"read-repica-db") == true ? null : var.username #var.username
  password               = endswith(var.name,"read-repica-db") == true ? null : var.password
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = var.skip_final_snapshot
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
  identifier             = var.name
  multi_az               = var.multi_az
  replicate_source_db    = endswith(var.name,"read-repica-db") == true ? trim(var.name,"-read-replica") : null
  tags = {
    Name        = var.name
    Project     = var.project
    Location    = var.location
    Environment = var.env
  }
  tags_all = {
    Name        = var.name
    Project     = var.project
    Location    = var.location
    Environment = var.env
  }
}