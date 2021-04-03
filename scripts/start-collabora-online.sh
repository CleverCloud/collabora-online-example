#! /usr/bin/env sh

# Replace trusted host and set admin username and password
perl -pi -e "s/<username (.*)>.*<\/username>/<username \1>${USERNAME}<\/username>/" /etc/loolwsd/loolwsd.xml
perl -pi -e "s/<password (.*)>.*<\/password>/<password \1>${PASSWORD}<\/password>/" /etc/loolwsd/loolwsd.xml
perl -pi -e "s/<server_name (.*)>.*<\/server_name>/<server_name \1>${SERVER_NAME}<\/server_name>/" /etc/loolwsd/loolwsd.xml
perl -pi -e "s/<allowed_languages (.*)>.*<\/allowed_languages>/<allowed_languages \1>${DICTIONARIES:-de_DE en_GB en_US es_ES fr_FR it nl pt_BR pt_PT ru}<\/allowed_languages>/" /etc/loolwsd/loolwsd.xml

# Generate WOPI proof key
loolwsd-generate-proof-key

# Start loolwsd
exec /usr/bin/loolwsd --port="${PORT}" --disable-ssl --version --o:sys_template_path=/opt/lool/systemplate --o:child_root_path=/opt/lool/child-roots --o:file_server_root_path=/usr/share/loolwsd --o:logging.color=false --o:user_interface.mode=notebookbar ${EXTRA_PARAMS}
