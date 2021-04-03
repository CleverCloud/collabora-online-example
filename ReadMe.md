# Collabora Online Server Example

> The purpose of this custom setup is to be deployed on Clever Cloud

It is inspired by the original Collabora Online Docker [setup](https://github.com/CollaboraOnline/online/tree/master/docker).

Server should answer `OK` on `/` and admin is accessible with the path `/loleaflet/dist/admin/admin.html`

## Deploy

```bash
clever create --type docker myCollaboraOnlineServer

cp .env.default .env
clever env set < .env

clever domain add mycollaboraonlineserver.cleverapps.io
clever deploy
```