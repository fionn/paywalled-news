data "cloudflare_zones" "apex" {
  filter {
    name       = var.apex_zone_name
    account_id = var.cloudflare_account_id
    status     = "active"
  }
}

resource "cloudflare_record" "spf" {
  zone_id = data.cloudflare_zones.apex.zones[0].id
  name    = "@"
  type    = "TXT"
  value   = "v=spf1 include:_spf.mx.cloudflare.net ~all"
}

resource "cloudflare_record" "dkim" {
  zone_id = data.cloudflare_zones.apex.zones[0].id
  name    = "*._domainkey"
  type    = "TXT"
  value   = "v=DKIM1; p="
}

resource "cloudflare_record" "dmarc" {
  zone_id = data.cloudflare_zones.apex.zones[0].id
  name    = "_dmarc"
  type    = "TXT"
  value   = "v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s;"
}

resource "cloudflare_record" "mx_route_1" {
  zone_id  = data.cloudflare_zones.apex.zones[0].id
  name     = "@"
  type     = "MX"
  value    = "route1.mx.cloudflare.net"
  priority = 74
}

resource "cloudflare_record" "mx_route_2" {
  zone_id  = data.cloudflare_zones.apex.zones[0].id
  name     = "@"
  type     = "MX"
  value    = "route2.mx.cloudflare.net"
  priority = 32
}

resource "cloudflare_record" "mx_route_3" {
  zone_id  = data.cloudflare_zones.apex.zones[0].id
  name     = "@"
  type     = "MX"
  value    = "route3.mx.cloudflare.net"
  priority = 32
}
