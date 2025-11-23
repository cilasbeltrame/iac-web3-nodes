output "instance_ips" {
  description = "Map of instance IP addresses keyed by instance identifier"
  value = {
    for k, v in contabo_instance.this : k => try(v.ip_config[0].v4.ip, null)
  }
}


