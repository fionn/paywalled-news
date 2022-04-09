variable "ft_destination_host" {
  type        = string
  description = "Host to reverse proxy"
}

variable "ft_referrer" {
  type        = string
  description = "HTTP referer header"
}

resource "cloudflare_record" "ft_a" {
  zone_id = data.cloudflare_zones.apex.zones[0].id
  name    = "ft"
  value   = "192.0.2.1"
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "ft_aaaa" {
  zone_id = data.cloudflare_zones.apex.zones[0].id
  name    = "ft"
  value   = "100::"
  type    = "AAAA"
  proxied = true
}

resource "cloudflare_worker_script" "ft" {
  name    = "ft"
  content = file("../reverse_proxy/worker/index.js")

  plain_text_binding {
    name = "DESTINATION_HOST"
    text = var.ft_destination_host
  }

  plain_text_binding {
    name = "REFERER"
    text = var.ft_referrer
  }
}

resource "cloudflare_worker_route" "ft_catchall" {
  zone_id     = data.cloudflare_zones.apex.zones[0].id
  pattern     = "${cloudflare_record.ft_a.hostname}/*"
  script_name = cloudflare_worker_script.ft.name
}
