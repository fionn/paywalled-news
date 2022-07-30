data "cloudflare_zones" "apex" {
  filter {
    name       = var.apex_zone_name
    account_id = var.cloudflare_account_id
    status     = "active"
  }
}

resource "cloudflare_zone_settings_override" "apex" {
  # https://github.com/cloudflare/terraform-provider-cloudflare/issues/1498#issuecomment-1063326790
  zone_id = data.cloudflare_zones.apex.zones[0].id
  settings {
    always_use_https         = "on"
    automatic_https_rewrites = "on"
    brotli                   = "on"
    http3                    = "on"
    ipv6                     = "on"
    opportunistic_encryption = "on"
    opportunistic_onion      = "on"
    zero_rtt                 = "on"
    tls_1_3                  = "zrt"
    min_tls_version          = "1.3"
    ssl                      = "strict"

    security_header {
      enabled            = true
      include_subdomains = true
      nosniff            = true
    }
  }
}

resource "cloudflare_zone_dnssec" "apex" {
  # May require two passes.
  # https://github.com/cloudflare/terraform-provider-cloudflare/issues/1486
  zone_id = data.cloudflare_zones.apex.zones[0].id
}

resource "cloudflare_record" "apex_a" {
  zone_id = data.cloudflare_zones.apex.zones[0].id
  name    = "@"
  type    = "A"
  value   = "192.0.2.1"
  proxied = true
}

resource "cloudflare_record" "apex_aaaa" {
  zone_id = data.cloudflare_zones.apex.zones[0].id
  name    = "@"
  type    = "AAAA"
  value   = "100::"
  proxied = true
}

resource "cloudflare_record" "www" {
  zone_id = data.cloudflare_zones.apex.zones[0].id
  name    = "www"
  type    = "CNAME"
  value   = cloudflare_record.apex_a.hostname
  proxied = true
}

resource "cloudflare_page_rule" "www_redirect" {
  zone_id  = data.cloudflare_zones.apex.zones[0].id
  target   = "${cloudflare_record.www.hostname}/*"
  priority = 1

  actions {
    forwarding_url {
      url         = "https://${cloudflare_record.apex_a.hostname}/$1"
      status_code = 301
    }
  }
}

resource "cloudflare_page_rule" "apex_root_redirect" {
  zone_id  = data.cloudflare_zones.apex.zones[0].id
  target   = "${cloudflare_record.apex_a.hostname}/"
  priority = 2

  actions {
    forwarding_url {
      url         = var.apex_root_redirect_url
      status_code = 302
    }
  }
}
