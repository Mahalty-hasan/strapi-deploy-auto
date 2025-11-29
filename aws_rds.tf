resource "aws_db_instance" "strapi" {
  identifier             = "strapi-db"
  allocated_storage      = 5
  db_name                = "strapiDB"
  engine                 = "postgres"
  engine_version         = "11.22"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = true
  skip_final_snapshot    = true

  # Recommend adding these for a production-like setup
  # backup_retention_period = 7
  # storage_type            = "gp2"
  # parameter_group_name    = "default.postgres11"
  # apply_immediately       = true
  # multi_az                = false

  # Optionally add tags block for resource identification
  # tags = {
  #   Name = "strapi-db"
  #   Environment = "production"
  # }
}

resource "null_resource" "rds_details" {
  provisioner "local-exec" {
    command = <<EOF
echo '{
  "database_hostname": "${aws_db_instance.strapi.address}",
  "database_name": "${aws_db_instance.strapi.db_name}",
  "database_username": "${aws_db_instance.strapi.username}"
}' > ./output/rds-details.json
EOF
  }
}
