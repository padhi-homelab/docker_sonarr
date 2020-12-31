FROM padhihomelab/alpine-base:edge as base
ARG TARGETARCH

ARG SONARR_VERSION=3.0.4.1042

ADD "https://download.sonarr.tv/v3/phantom-develop/${SONARR_VERSION}/Sonarr.phantom-develop.${SONARR_VERSION}.linux.tar.gz" \
    /tmp/sonarr.tar.gz

COPY sonarr.sh       /usr/local/bin/sonarr
COPY setup-volume.sh /etc/docker-entrypoint.d/setup-volume.sh

RUN chmod +x /etc/docker-entrypoint.d/setup-volume.sh \
             /usr/local/bin/sonarr \
 && apk add --no-cache --update \
            --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
            ca-certificates \
            libmediainfo \
            mono \
            sqlite-libs \
            tzdata \
 && cd /tmp \
 && tar -xvzf sonarr.tar.gz \
 && rm -rf Sonarr/Sonarr.Update \
           /tmp/sonarr.tar.gz \
 && mv /tmp/Sonarr /sonarr \
 && (cert-sync /etc/ssl/certs/ca-certificates.crt || true)

EXPOSE 8989
VOLUME [ "/config", "/downloads", "/tv" ]

CMD [ "sonarr" ]

HEALTHCHECK --start-period=10s --interval=30s --timeout=5s --retries=3 \
        CMD ["wget", "--tries", "5", "-qSO", "/dev/null",  "http://localhost:8989/"]
