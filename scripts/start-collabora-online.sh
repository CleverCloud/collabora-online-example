#! /usr/bin/env bash

set -eux

# Generate WOPI proof key
loolwsd-generate-proof-key

# Start loolwsd
exec /usr/bin/loolwsd \
    --port="${PORT}" \
    --version \
    --override:sys_template_path=/opt/lool/systemplate \
    --override:child_root_path=/opt/lool/child-roots \
    --override:file_server_root_path=/usr/share/loolwsd \
    --override:logging.color=false \
    --override:user_interface.mode=notebookbar \
    --override:ssl.enable=false \
    --override:ssl.termination=true \
    --override:mount_jail_tree=false \
    --override:net.post_allow.host[0]=.\{1,99\} \
    --override:server_name="${SERVER_NAME}" \
    --override:admin_console.username="${ADMIN_USERNAME}" \
    --override:admin_console.password="${ADMIN_PASSWORD}" \
    --override:allowed_languages="${DICTIONARIES:-en_GB en_US fr_FR}" \
    --override:storage.wopi.host[0]="${AUTHORIZED_DOMAIN}" \
    ${EXTRA_PARAMS}
