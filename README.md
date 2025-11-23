# Web3 Nodes Infrastructure

Terraform configuration for provisioning blockchain nodes on Contabo VPS instances. Currently set up for Ethereum (Geth) nodes, but the module can be extended for other chains.

## What's in here

- **`terraform-modules/contabo-instance/`** - Reusable Terraform module for creating Contabo VPS instances
- **`nodes/`** - Infrastructure configuration that uses the module to spin up actual nodes
- **`nodes/user-data/`** - Cloud-init scripts that run on instance startup to configure the nodes
