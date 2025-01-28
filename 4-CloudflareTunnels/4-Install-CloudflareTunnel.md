Configure home-proxmox-01

Name your tunnel
>

Install and run connectors
>

Route tunnel
Choose your environment
Choose an operating system:

Windows

Mac

Debian

Red Hat

Docker
Content Loaded
Install and run a connector
To connect your tunnel to Cloudflare, copy-paste one of the following commands into a terminal window. Remotely managed tunnels require that you install cloudflared 2022.03.04 or later.
Store your token carefully. This command includes a sensitive token that allows the connector to run. Anyone with access to this token will be able to run the tunnel.
Content Loaded


$
docker run cloudflare/cloudflared:latest tunnel --no-autoupdate run --token eyJhIjoiNDE3MjIzNjcyM2I3N2I1OTI1ZGU1YzJiOTFiM2NlZTkiLCJ0IjoiNzkzNmNmY2QtOTE0OC00NWM0LTg5NzctMWViMDQ0ZGQ4NjkyIiwicyI6Ik9HSmpOemd3TkRNdFpUTTBPQzAwTURjeExXSXlZVEl0T0dWak5ESmtaVGt4WVdJdyJ9



docker run -d cloudflare/cloudflared:latest tunnel --no-autoupdate run --token eyJhIjoiNDE3MjIzNjcyM2I3N2I1OTI1ZGU1YzJiOTFiM2NlZTkiLCJ0IjoiNzkzNmNmY2QtOTE0OC00NWM0LTg5NzctMWViMDQ0ZGQ4NjkyIiwicyI6Ik9HSmpOemd3TkRNdFpUTTBPQzAwTURjeExXSXlZVEl0T0dWak5ESmtaVGt4WVdJdyJ9



View Frequently Asked Questions This link opens in a new tab
Connectors
