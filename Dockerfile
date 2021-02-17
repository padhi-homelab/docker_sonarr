FROM padhihomelab/debian-base:10.0_0.19.0_git.212b7514

ARG SONARR_VERSION=3.0.4.1129

ADD "https://download.sonarr.tv/v3/phantom-develop/${SONARR_VERSION}/Sonarr.phantom-develop.${SONARR_VERSION}.linux.tar.gz" \
    /tmp/sonarr.tar.gz

COPY sonarr.sh       /usr/local/bin/sonarr
COPY setup-volume.sh /etc/docker-entrypoint.d/setup-volume.sh

RUN chmod +x /etc/docker-entrypoint.d/setup-volume.sh \
             /usr/local/bin/sonarr \
 && cd /tmp \
 && tar -xvzf sonarr.tar.gz \
 && rm -rf Sonarr/Sonarr.Update \
           /tmp/sonarr.tar.gz \
 && mv /tmp/Sonarr /sonarr \
 && apt update \
 && apt install -yq apt-transport-https dirmngr gnupg ca-certificates \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
 && echo "deb https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
 && apt update \
 && apt upgrade -yq \
 && apt install -yq ca-certificates-mono \
                    libmediainfo0v5 \
                    mono-devel \
                    wget \
 && apt autoremove -yq \
 && apt clean

EXPOSE 8989
VOLUME [ "/config", "/downloads", "/tv" ]

CMD [ "sonarr" ]

HEALTHCHECK --start-period=10s --interval=30s --timeout=5s --retries=3 \
        CMD ["wget", "--tries", "5", "-qSO", "/dev/null",  "http://localhost:8989/"]
