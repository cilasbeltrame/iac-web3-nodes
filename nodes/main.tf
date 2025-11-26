variable "root_passwords" {
  description = "Root passwords for instances (provide via TF_VAR_root_passwords env var)"
  type        = map(string)
  default     = {}
  sensitive   = true
}

module "blockchain_nodes" {
  source = "../terraform-modules/contabo-instance"
  
  vps_instances_config = {
    geth-node-1 = {
      display_name = "geth-node-1"
      # https://api.contabo.com/#tag/Instances/operation/createInstance
      # 1200 GB nvme
      # 24 GB RAM
      # 8 CPU cores
      product_id   = "V99"
      region       = "EU"
      user_data    =  base64encode(file("${path.module}/user-data/geth-node-1.sh"))
    }
  }

  # root_passwords keys must match vps_instances_config keys
  # Only include entries for instances that need a root password
  # Provide via TF_VAR_root_passwords environment variable as JSON:
  # export TF_VAR_root_passwords='{"geth-node-1":"your-secure-password"}'
  root_passwords = var.root_passwords
}
