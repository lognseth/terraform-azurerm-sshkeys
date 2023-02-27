variable "use_case" {
  type        = string
  description = "The use case for the keypair, for example aks or vms"
}

variable "environment_name" {
  type        = string
  description = "The environment the keypair will be used in, for example dev"
}

variable "key_vault_id" {
  description = "The ID of the key vault the keypair will be saved to"
}

variable "expiry_date" {
  type        = number
  description = "The expiration time of the secret, in years, for example 1"
  default     = 3
}
