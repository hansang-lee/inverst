ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND="noninteractive"

#
# user
#

RUN apt-get -qq update \
    && apt-get install -y --fix-missing --no-install-recommends sudo \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
ARG USER_NAME=hslee
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
RUN groupadd --gid ${USER_GID} ${USER_NAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USER_NAME} \
    && echo ${USER_NAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER_NAME} \
    && echo ${USER_NAME} ALL=\(root\) NOPASSWD:ALL >> /etc/sudoers \
    && usermod -a -G video ${USER_NAME} \
    && chmod 0440 /etc/sudoers.d/${USER_NAME}

#
# basics
#

RUN apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends \
    git \
    cmake \
    curl \
    wget \
    doxygen \
    lsb-release \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

#
# clang-format
#

RUN apt-get -qq update \
    && apt-get install -y --fix-missing --no-install-recommends \
    wget tar xz-utils ca-certificates lsb-release software-properties-common gnupg \
    && wget https://apt.llvm.org/llvm.sh \
    --tries=10 \
    --continue \
    --directory-prefix=/tmp \
    && chmod +x /tmp/llvm.sh \
    && /tmp/llvm.sh all 18 \
    && ln -s /usr/bin/clang-format-18 /usr/local/bin/clang-format

RUN apt-get -qq update \
    && apt-get install -y --fix-missing --no-install-recommends \
    libcurl4-openssl-dev \
    libjsoncpp-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

USER hslee

ENV SHELL /bin/bash
