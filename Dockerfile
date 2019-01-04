# Download MaxMind DB's
FROM alpine AS download

WORKDIR /root/

ADD http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz /root/
ADD http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz /root/
RUN gzip -d GeoLite2-Country.mmdb.gz
RUN gzip -d GeoLite2-City.mmdb.gz


# Final Image
FROM mpolden/echoip

WORKDIR /opt/echoip

COPY --from=download /root/GeoLite2* /opt/echoip/

COPY index.html /opt/echoip/index.html

EXPOSE 8080

CMD [ "/opt/echoip/echoip","--country-db", "/opt/echoip/GeoLite2-Country.mmdb", "--city-db", "/opt/echoip/GeoLite2-City.mmdb", "--port-lookup", "--reverse-lookup", "--trusted-header", "CF-Connecting-IP", "--trusted-header", "X-Forwarded-For", "--template", "/opt/echoip/index.html" ]