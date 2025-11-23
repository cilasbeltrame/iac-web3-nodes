terraform {
  required_providers {
    contabo = {
      source  = "contabo/contabo"
      version = ">= 0.1.32"
    }
  }
}

provider "contabo" {
}

variable "root_passwords" {
  description = "Root passwords for instances (provide via TF_VAR_root_passwords env var)"
  type        = map(string)
  default     = {}
  sensitive   = true
}

module "eth_nodes" {
  source = "../"
  
  vps_instances_config = {
    eth_node_1 = {
      display_name = "eth_node_1"
      product_id   = "V92"
      region       = "EU"
    }
    eth_node_2 = {
      display_name = "eth_node_2"
      product_id   = "V92"
      region       = "EU"
    }
  }

  # root_passwords keys must match vps_instances_config keys
  # Only include entries for instances that need a root password
  # Provide via TF_VAR_root_passwords environment variable as JSON:
  # export TF_VAR_root_passwords='{"eth_node_1":"your-secure-password"}'
  # Or omit to use ssh_keys instead (recommended)
  root_passwords = var.root_passwords
}
