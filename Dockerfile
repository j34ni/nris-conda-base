FROM ubuntu:22.04

# Authors Jean Iaquinta
# Contact jeani@uio.no
# Version v1.0.0

# This is a Dockerfile for a base Ubuntu 22.04 container with MiniConda py39_24.7.1-0 for NRIS Users to install their own packages

RUN apt-get update -y && \
    ln -fs /usr/share/zoneinfo/Europe/Oslo /etc/localtime && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libgl1 locales micro tzdata wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV miniconda='Miniconda3-py39_24.7.1-0-Linux-x86_64.sh' \
    EBROOTMINICONDA3=/usr/local/conda

RUN wget -q -nc --no-check-certificate -P /var/tmp https://repo.anaconda.com/miniconda/$miniconda && \
    bash /var/tmp/$miniconda -b -p $EBROOTMINICONDA3 && \
    rm /var/tmp/$miniconda

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 

RUN mkdir -p /nird /cluster /opt/uio/.tmp

RUN echo '#!/bin/bash' > /opt/uio/start.sh && \
    echo 'source ${EBROOTMINICONDA3}/etc/profile.d/conda.sh' >> /opt/uio/start.sh && \
    echo 'conda activate' >> /opt/uio/start.sh && \
    echo 'exec "$@"' >> /opt/uio/start.sh && \
    chmod ugo+rwx /opt/uio/start.sh

ENTRYPOINT ["/opt/uio/start.sh"]
CMD ["/bin/bash"]
