FROM padhihomelab/debian-base:11.3_0.19.0_git.212b7514

ARG SONARR_VERSION=3.0.8.1507

ADD "https://download.sonarr.tv/v3/main/${SONARR_VERSION}/Sonarr.main.${SONARR_VERSION}.linux.tar.gz" \
    /tmp/sonarr.tar.gz

COPY sonarr.sh \
     /usr/local/bin/sonarr
COPY entrypoint-scripts \
     /etc/docker-entrypoint.d/99-extra-scripts

RUN chmod +x /etc/docker-entrypoint.d/99-extra-scripts/*.sh \
             /usr/local/bin/sonarr \
 && cd /tmp \
 && tar -xvzf sonarr.tar.gz \
 && rm -rf Sonarr/Sonarr.Update \
           /tmp/sonarr.tar.gz \
 && mv /tmp/Sonarr /sonarr \
 && apt update \
 && apt install -yq apt-transport-https \
                    dirmngr \
                    gnupg \
                    ca-certificates \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
 # TODO: Switch to `stable-bullseye` channel when available
 && echo "deb https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-stable.list \
 && update-ca-certificates -v \
 && apt update \
 && apt upgrade -yq \
 && apt install -yq ca-certificates-mono \
                    libmediainfo0v5 \
                    mono-devel \
                    tzdata \
                    wget \
 && apt autoremove -yq \
 && apt clean

EXPOSE 8989
VOLUME [ "/config", "/downloads", "/tv" ]

CMD [ "sonarr" ]

HEALTHCHECK --start-period=10s --interval=30s --timeout=5s --retries=3 \
        CMD ["wget", "--tries", "5", "-qSO", "/dev/null",  "http://localhost:8989/"]
