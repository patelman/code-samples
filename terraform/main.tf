module "customer-suggestion" {
  source = "./customer"

  # Set any required variables here, e.g. security groups, VPC ID, etc.
  service_name = "customer-suggestion"
  db_name = "customersuggestiondb"
  rds_instance_class = "db.t2.micro"
}

module "customer-feedback" {
  source = "./customer"

  # Set any required variables here, e.g. security groups, VPC ID, etc.
  service_name = "customer-feedback-tmp" // <-- customer-feedback bucket already exist
  db_name = "customerfeedbackdb"
  rds_instance_class = "db.t2.micro"
}

