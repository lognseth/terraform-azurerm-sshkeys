locals {
  years          = 365 * var.expiry_date
  hoursRaw       = local.years * 24
  hours_to_str   = tostring(local.hoursRaw)
  hours          = "${local.hours_to_str}h"
  current_time   = timestamp()
  expiry_time    = timeadd(local.current_time, local.hours)
  formatted_time = formatdate("YYYY-MM-DD", local.expiry_time)
  time_to_expiry = "${local.formatted_time}T00:00:00+00:00"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "private_key" {
  name            = "${var.use_case}-${var.environment_name}-ssh-private-key"
  value           = tls_private_key.ssh.private_key_pem
  key_vault_id    = var.key_vault_id
  content_type    = "SSH PRIVATE KEY"
  expiration_date = local.time_to_expiry
  tags = {
    environment = var.environment_name
  }

  lifecycle {
    ignore_changes = [
      expiration_date
    ]
  }
}

resource "azurerm_key_vault_secret" "public_key" {
  name            = "${var.use_case}-${var.environment_name}-ssh-public-key"
  value           = tls_private_key.ssh.public_key_openssh
  content_type    = "SSH PUBLIC KEY"
  expiration_date = local.time_to_expiry
  key_vault_id    = var.key_vault_id
  tags = {
    environment = var.environment_name
  }

  lifecycle {
    ignore_changes = [
      expiration_date
    ]
  }
}
