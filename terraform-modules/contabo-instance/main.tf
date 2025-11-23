# Create contabo VPS instances
resource "contabo_instance" "this" {
  for_each = var.vps_instances_config

  display_name = each.value.display_name
  product_id   = each.value.product_id
  region       = each.value.region
  period       = each.value.period
  image_id     = each.value.image_id
  ssh_keys     = each.value.ssh_keys
  root_password = lookup(var.root_passwords, each.key, null)
  user_data = each.value.user_data
}