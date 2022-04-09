data "cloudflare_zones" "apex" {
  filter {
    name       = var.apex_zone_name
    account_id = var.cloudflare_account_id
    status     = "active"
  }
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

resource "cloudflare_page_rule" "always_use_https" {
  zone_id  = data.cloudflare_zones.apex.zones[0].id
  target   = "http://*${cloudflare_record.apex_a.hostname}/*"
  priority = 3

  actions {
    always_use_https = true
  }
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
