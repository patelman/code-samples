# define input variables with defaults
variable "region" {
  description = "AWS region where resources will be provisioned"
  type        = string
  default     = "us-east-1"
}
variable "service_name" {
  description = "Service name"
  type        = string
  default     = "customer-suggestion"
}
# DB name can only have alphanumeric chars,so removing hyphen from the service name
variable "db_name" {
  description = "Service name"
  type        = string
  default     = "customersuggestion"
}

variable "environment" {
  description = "Environment name for the microservice"
  type        = string
  default     = "dev"
}

variable "rds_instance_class" {
  description = "Instance class for the RDS MySQL instance"
  type        = string
  default     = "db.t2.micro"
}

variable "rds_username" {
  description = "Username for the RDS MySQL instance"
  type        = string
  default     = "admin"
}

variable "rds_password" {
  description = "Password for the RDS MySQL instance"
  type        = string
  default     = "Passw0rd!"
}
