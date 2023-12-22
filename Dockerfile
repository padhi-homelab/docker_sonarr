FROM padhihomelab/alpine-base:3.19.0_0.19.0_0.2 as base
ARG TARGETARCH

FROM base AS base-amd64
ENV SONARR_ARCH=x64

FROM base AS base-arm64
ENV SONARR_ARCH=arm64

FROM base AS base-armv7
ENV SONARR_ARCH=arm

FROM base-${TARGETARCH}${TARGETVARIANT}

ARG SONARR_VERSION=4.0.0.738
ARG SONARR_BRANCH=develop

ADD "https://download.sonarr.tv/v4/${SONARR_BRANCH}/${SONARR_VERSION}/Sonarr.${SONARR_BRANCH}.${SONARR_VERSION}.linux-musl-${SONARR_ARCH}.tar.gz" \
    /tmp/sonarr.tar.gz

COPY sonarr.sh \
     /usr/local/bin/sonarr
COPY entrypoint-scripts \
     /etc/docker-entrypoint.d/99-extra-scripts

RUN chmod +x /etc/docker-entrypoint.d/99-extra-scripts/*.sh \
             /usr/local/bin/sonarr \
 && apk add --no-cache --update \
            icu-libs \
            libintl \
            libmediainfo \
            sqlite-libs \
            tzdata \
 && cd /tmp \
 && tar -xvzf sonarr.tar.gz \
 && rm -rf Sonarr/Sonarr.Update \
           /tmp/sonarr.tar.gz \
 && mv /tmp/Sonarr /sonarr

EXPOSE 8989
VOLUME [ "/config", "/downloads", "/tv" ]

CMD [ "sonarr" ]

HEALTHCHECK --start-period=10s --interval=30s --timeout=5s \
        CMD ["wget", "--tries", "5", "-qSO", "/dev/null",  "http://127.0.0.1:8989/"]
