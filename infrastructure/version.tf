terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.20.0"
    }
  }
  required_version = ">= 1"
}

provider "cloudflare" {
  account_id = var.cloudflare_account_id # required for worker-related calls
  api_token  = var.cloudflare_api_token
}
