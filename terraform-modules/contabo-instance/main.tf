# Create password secrets if root_passwords are provided
# Use nonsensitive() to extract keys for for_each, then access values from the sensitive variable
resource "contabo_secret" "root_passwords" {
  for_each = { for k in keys(nonsensitive(var.root_passwords)) : k => k }

  name  = "${each.key}-root-password"
  value = var.root_passwords[each.key]
  type  = "password"
}

# Create contabo VPS instances
resource "contabo_instance" "this" {
  for_each = var.vps_instances_config

  display_name = each.value.display_name
  product_id   = each.value.product_id
  region       = each.value.region
  period       = each.value.period
  image_id     = each.value.image_id
  ssh_keys     = each.value.ssh_keys
  # root_password expects a secret ID (integer), not the password string
  # The secret ID is stored as a string in Terraform, so we convert it to number
  root_password = lookup(var.root_passwords, each.key, null) != null ? tonumber(contabo_secret.root_passwords[each.key].id) : null
  user_data = each.value.user_data
}