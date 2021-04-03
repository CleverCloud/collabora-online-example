FROM collabora/code:latest

# ADD /config/loolwsd.xml /etc/loolwsd/loolwsd.xml
ADD /scripts/start-collabora-online.sh /

EXPOSE ${PORT}