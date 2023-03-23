variable "environment_suffix" {
  type        = string
  description = "procure le suffix indiquant l'environement cible"
}

variable "project_name" {
  type = string
}

variable "port" {
  type = number
}

variable "db_host" {
  type = string
}

variable "db_database" {
  type = string
}

variable "db_dailect" {
  type = string
}

variable "db_port" {
  type = number
}

variable "access_token_expiry" {
  type = string
}

variable "refresh_token_expiry" {
  type = string
}

variable "refresh_token_cookie_name" {
  type = string
}
