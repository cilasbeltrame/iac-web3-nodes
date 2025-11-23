
variable "vps_instances_config" {
  description = "Map of VPS instances to create. Key is the instance identifier, value contains instance configuration."
  type = map(object({
    display_name = string
    product_id   = string
    region       = string
    period       = optional(number, 3)
    user_data    = optional(string)
    image_id     = optional(string)
    ssh_keys     = optional(list(number))
  }))
  default = {}
}

variable "root_passwords" {
  description = "Map of root passwords keyed by instance identifier. Use TF_VAR_root_passwords env var, sensitive workspace vars, or secret management. Recommended: use ssh_keys instead."
  type        = map(string)
  default     = {}
  sensitive   = true
}

