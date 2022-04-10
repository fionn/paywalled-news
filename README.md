# Paywalled News

> _The Truth Is Paywalled But The Lies Are Free_

## Authentication

You need to pass the provider your `account_id` (workers are account-level resources).
Then you can authenticate either with `email` and `api_key`, or with `api_token`.

If you use a token, you need the following scopes:
* _user_:
    * Workers Scripts:Edit,
    * Account Settings:Read,
    * _apex zone_:
        * Zone Settings:Edit,
        * Workers Routes:Edit,
        * Page Rules:Edit,
        * DNS:Edit,
* All users:
    * User Details:Read.

## Configuration

You must specify:

* `apex_zone_name`, the hostname of the zone to deploy to,
* `apex_root_redirect_url`, the URL to 302 redirect to from `/`,
* `ft_destination_host`, the host you want to proxy traffic to,
* `ft_referrer`, the HTTP `Referer` header (optional).

## Deployment

```bash
terraform apply
```
