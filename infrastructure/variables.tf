variable "apex_zone_name" {
  type        = string
  description = "Apex zone to host subdomains for the workers"
}

variable "apex_root_redirect_url" {
  type        = string
  description = "URL to redirect / to on the apex domain"
}

variable "cloudflare_account_id" {
  type        = string
  description = "The hexadecimal string in the dashboard URL"
}

variable "cloudflare_api_token" {
  type        = string
  description = "API token from https://dash.cloudflare.com/profile/api-tokens"
}
