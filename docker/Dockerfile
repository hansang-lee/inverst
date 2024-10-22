FROM ubuntu:22.04

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
