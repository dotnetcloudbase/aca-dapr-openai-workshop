variable "user_group_name" {
  description = "The name of the user group"
  type        = string
  default     = "aca-dapr-user-group"
}

variable "domain_name" {
  description = "The name of the Azure AD tenant e.g MngEnv123456.onmicrosoft.com"
  type        = string
}

variable "user_default_password" {
  description = "The user default password inside the Azure AD tenant"
  type        = string
}

variable "users" {
  description = "The users"
  type = list(object({
    name                    = string
    resource_group_name     = string
    resource_group_location = string
  }))
}
