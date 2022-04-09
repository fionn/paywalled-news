data "cloudflare_zones" "apex" {
  filter {
    name       = var.apex_zone_name
    account_id = var.cloudflare_account_id
    status     = "active"
  }
}
