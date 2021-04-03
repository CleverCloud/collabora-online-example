#!/bin/sh
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Copied from https://github.com/CollaboraOnline/online/blob/master/docker/from-packages/scripts/start-collabora-online.sh

# Fix domain name resolution from jails
cp /etc/resolv.conf /etc/hosts /opt/lool/systemplate/etc/

# Disable warning/info messages of LOKit by default
if test "${SAL_LOG-set}" == set; then
SAL_LOG="-INFO-WARN"
fi

# Replace trusted host and set admin username and password
perl -pi -e "s/<username (.*)>.*<\/username>/<username \1>${USERNAME}<\/username>/" /etc/loolwsd/loolwsd.xml
perl -pi -e "s/<password (.*)>.*<\/password>/<password \1>${PASSWORD}<\/password>/" /etc/loolwsd/loolwsd.xml
perl -pi -e "s/<server_name (.*)>.*<\/server_name>/<server_name \1>${SERVER_NAME}<\/server_name>/" /etc/loolwsd/loolwsd.xml
perl -pi -e "s/<allowed_languages (.*)>.*<\/allowed_languages>/<allowed_languages \1>${DICTIONARIES:-de_DE en_GB en_US es_ES fr_FR it nl pt_BR pt_PT ru}<\/allowed_languages>/" /etc/loolwsd/loolwsd.xml

# Restart when /etc/loolwsd/loolwsd.xml changes
[ -x /usr/bin/inotifywait -a /usr/bin/killall ] && (
  /usr/bin/inotifywait -e modify /etc/loolwsd/loolwsd.xml
  echo "$(ls -l /etc/loolwsd/loolwsd.xml) modified --> restarting"
  /usr/bin/killall -1 loolwsd
) &

# Generate WOPI proof key
loolwsd-generate-proof-key

# Start loolwsd
exec /usr/bin/loolwsd --port="${PORT}" --disable-ssl --version --o:sys_template_path=/opt/lool/systemplate --o:child_root_path=/opt/lool/child-roots --o:file_server_root_path=/usr/share/loolwsd --o:logging.color=false --o:user_interface.mode=notebookbar ${EXTRA_PARAMS}
