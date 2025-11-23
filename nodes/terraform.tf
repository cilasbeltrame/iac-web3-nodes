terraform {
  required_providers {
    contabo = {
      source  = "contabo/contabo"
      version = ">= 0.1.32"
    }
  }

  backend "s3" {
    bucket = "iac-web3-nodes-terraform-state"
    key    = "testnet/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "contabo" {
  # OAuth2 credentials are read from environment variables:
  # CONTABO_OAUTH2_CLIENT_ID
  # CONTABO_OAUTH2_CLIENT_SECRET
  # CONTABO_OAUTH2_USERNAME
  # CONTABO_OAUTH2_PASSWORD
}
