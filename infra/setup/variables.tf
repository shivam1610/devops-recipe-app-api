variable "tf_state_bucket" {
  description = "Name of S3 bucket in AWS for stroring TF state"
  default     = "devops-recipe-app-tf-state-123456"

}

variable "tf_state_lock_table" {
  description = "Name of DynamoDB table for TF state locking"
  default     = "devops-recipe-app-api-tf-lock"
}

variable "project" {
  description = "Project name for tagging resources"
  default     = "recipe-app-api"
}

variable "contact" {
  description = "Contact name for tagging resources"
  default     = "devops-team@example.com" # replace with the email of the team or individual responsible for the project
}