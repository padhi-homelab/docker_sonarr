# docker_sonarr <a href='https://github.com/padhi-homelab/docker_sonarr/actions?query=workflow%3A%22Docker+CI+Release%22'><img align='right' src='https://img.shields.io/github/workflow/status/padhi-homelab/docker_sonarr/Docker%20CI%20Release?logo=github&logoWidth=24&style=flat-square'></img></a>

<a href='https://hub.docker.com/r/padhihomelab/sonarr'><img src='https://img.shields.io/docker/image-size/padhihomelab/sonarr/latest?label=size%20%5Blatest%5D&logo=docker&logoWidth=24&style=for-the-badge'></img></a>
<a href='https://hub.docker.com/r/padhihomelab/sonarr'><img src='https://img.shields.io/docker/image-size/padhihomelab/sonarr/testing?label=size%20%5Btesting%5D&logo=docker&logoWidth=24&style=for-the-badge'></img></a>

A multiarch [Sonarr] Docker image, based on [Debian Linux].

|           386            |       amd64        |          arm/v6          |       arm/v7       |       arm64        |         ppc64le          |          s390x           |
| :----------------------: | :----------------: | :----------------------: | :----------------: | :----------------: | :----------------------: | :----------------------: |
| :heavy_multiplication_x: | :heavy_check_mark: | :heavy_multiplication_x: | :heavy_check_mark: | :heavy_check_mark: | :heavy_multiplication_x: | :heavy_multiplication_x: |

## Usage

```
docker run --detach \
           -p 8989:8989 \
           -e DOCKER_UID=`id -u` \
           -v /path/to/store/configs:/configs \
           -v /path/to/client/downloads:/downloads \
           -v /path/to/library/for/tv_shows:/tv \
           -it padhihomelab/sonarr
```

Runs `Sonarr` with WebUI served on port 8989.

_<More details to be added soon>_


[Debian Linux]: https://debian.org/
[Sonarr]:       https://sonarr.tv/
