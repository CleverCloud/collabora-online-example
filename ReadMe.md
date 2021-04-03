# Collabora Online Server

> This custom setup purpose is to be deployed on Clever Cloud

It is inspired from original Collabora Online Docker [setup](https://github.com/CollaboraOnline/online/tree/master/docker).

Server should answer `OK` on `/` and admin is accessible with the path `/loleaflet/dist/admin/admin.html`

## Deploy

```bash
clever create --type docker myCollaboraOnlineServer

cp .env.default .env
clever env set < .env

clever domain add mycollaboraonlineserver.cleverapps.io
clever deploy
```