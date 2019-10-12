# Download MaxMind DB's
FROM alpine AS download

WORKDIR /root/

ADD https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz /root/
ADD https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz /root/
ADD https://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz /root/
RUN gzip -d GeoLite2-Country.mmdb.gz
RUN gzip -d GeoLite2-City.mmdb.gz
RUN tar -xzf GeoLite2-ASN.tar.gz "GeoLite2-ASN_20191008/GeoLite2-ASN.mmdb" --strip-components 1 -C /root/


# Final Image
FROM mpolden/echoip

WORKDIR /opt/echoip

COPY --from=download /root/GeoLite2* /opt/echoip/

COPY index.html /opt/echoip/index.html

EXPOSE 8080

CMD [ "/opt/echoip/echoip","--country-db", "/opt/echoip/GeoLite2-Country.mmdb", "--city-db", "/opt/echoip/GeoLite2-City.mmdb", "--asn-db", "/opt/echoip/GeoLite2-ASN.mmdb",  "--port-lookup", "--reverse-lookup", "--trusted-header", "CF-Connecting-IP", "--trusted-header", "X-Forwarded-For", "--template", "/opt/echoip/index.html" ]
