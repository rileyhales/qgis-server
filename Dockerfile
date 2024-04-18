# Description: Dockerfile for QGIS Server
# usage: docker build -f Dockerfile -t qgis-server ./
# Dockerfile reference: https://docs.qgis.org/3.34/en/docs/server_manual/containerized_deployment.html
#                       use --init in docker run command instead of adding tini to the image
# Server config environment variables reference: https://docs.qgis.org/3.34/en/docs/server_manual/config.html

FROM debian:bookworm-slim
ENV LANG=en_EN.UTF-8

RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests --allow-unauthenticated -y \
        gnupg ca-certificates wget locales \
    && localedef -i en_US -f UTF-8 en_US.UTF-8 \
    # Add the current key for package downloading
    # Please refer to QGIS install documentation (https://www.qgis.org/fr/site/forusers/alldownloads.html#debian-ubuntu)
    && mkdir -m755 -p /etc/apt/keyrings \
    && wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg \
    # Add repository for latest version of qgis-server
    # Please refer to QGIS repositories documentation if you want other version (https://qgis.org/en/site/forusers/alldownloads.html#repositories)
    && echo "deb [signed-by=/etc/apt/keyrings/qgis-archive-keyring.gpg] https://qgis.org/debian bookworm main" | tee /etc/apt/sources.list.d/qgis.list \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests --allow-unauthenticated -y \
        qgis-server spawn-fcgi xauth xvfb \
    && apt-get remove --purge -y gnupg wget \
    && rm -rf /var/lib/apt/lists/*

# QGIS Server environment variables
ENV QGIS_PREFIX_PATH /usr
ENV QGIS_SERVER_LOG_STDERR 1
ENV QGIS_SERVER_LOG_LEVEL 2
ENV QGIS_SERVER_PARALLEL_RENDERING 1
ENV QGIS_SERVER_MAX_THREADS -1
ENV QGIS_SERVER_IGNORE_BAD_LAYERS 1
ENV QGIS_SERVER_CACHE_SIZE 20000

# Set users and permissions
RUN useradd -m qgis
COPY cmd.sh /home/qgis/cmd.sh
RUN chmod -R 777 /home/qgis/cmd.sh
RUN chown qgis:qgis /home/qgis/cmd.sh
USER qgis
WORKDIR /home/qgis

ENTRYPOINT ["/bin/bash", "--"]

CMD ["/home/qgis/cmd.sh"]
