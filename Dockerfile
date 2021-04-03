FROM collabora/code:6.4.7.4-amd64

# ADD /config/loolwsd.xml /etc/loolwsd/loolwsd.xml
ADD /scripts/start-collabora-online.sh /

EXPOSE ${PORT}