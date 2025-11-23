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
}
