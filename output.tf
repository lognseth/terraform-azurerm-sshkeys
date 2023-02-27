output "ssh_public_key" {
  # Only output a generated ssh public key
  value = tls_private_key.ssh.public_key_openssh
}
