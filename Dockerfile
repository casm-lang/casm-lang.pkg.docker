#
#   Copyright (C) 2018-2022 CASM Organization <https://casm-lang.org>
#   All rights reserved.
#
#   Developed by: Philipp Paulweber et al.
#                 <https://github.com/casm-lang/casm-lang.pkg.docker/graphs/contributors>
#
#   This file is part of casm-lang.pkg.docker.
#
#   casm-lang.pkg.docker is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   casm-lang.pkg.docker is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with casm-lang.pkg.docker. If not, see <http://www.gnu.org/licenses/>.
#

ARG RELEASE=0.6.0
ARG PACKAGE=casm
ARG MONACO=casm-lang.plugin.monaco
ARG OS=linux
ARG ARCH=x86_64
ARG ARCHIVE=tar.gz
ARG URL=https://github.com/casm-lang/$PACKAGE/releases/download/$RELEASE/$PACKAGE-$OS-$ARCH.$ARCHIVE
ARG EXT=https://github.com/casm-lang/$MONACO/archive/$RELEASE.$ARCHIVE

FROM alpine as source
ARG RELEASE
ARG PACKAGE
ARG MONACO
ARG OS
ARG ARCH
ARG ARCHIVE
ARG URL
ARG EXT

RUN wget -qO  /tmp/archive.tar.gz --no-check-certificate $URL \
&&  tar  -xf  /tmp/archive.tar.gz -C /tmp \
&&  rm   -f   /tmp/archive.tar.gz \
&&  wget -qO  /tmp/archive.tar.gz --no-check-certificate $EXT \
&&  tar  -xf  /tmp/archive.tar.gz -C /tmp \
&&  rm   -f   /tmp/archive.tar.gz

FROM node:buster-slim
ARG RELEASE
ARG PACKAGE
ARG MONACO
ARG OS
ARG ARCH
ARG ARCHIVE
ARG URL
ARG EXT

RUN echo "deb http://ftp.us.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list \
 && apt -y update \
 && apt -y install build-essential
RUN mkdir -p /opt
WORKDIR /opt
COPY --from=source /tmp/$PACKAGE-$RELEASE /usr
COPY --from=source /tmp/$MONACO-$RELEASE .
RUN chown root.root /usr/bin/casmi /usr/bin/casmd /usr/bin/casmf 
RUN chmod +x        /usr/bin/casmi /usr/bin/casmd /usr/bin/casmf
RUN casmi --version
RUN casmd --version
RUN casmf --version
RUN npm install \
&&  npm run build

RUN echo "#!/bin/sh"                      > /usr/local/bin/editor \
&&  echo "(cd /opt; npm run standalone)" >> /usr/local/bin/editor \
&&  chmod +x /usr/local/bin/editor

EXPOSE 8080 8010

CMD ["/bin/bash"]

LABEL maintainer ppaulweber
