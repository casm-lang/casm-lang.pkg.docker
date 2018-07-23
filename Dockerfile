#
#   Copyright (C) 2018 CASM Organization <https://casm-lang.org>
#   All rights reserved.
#
#   Developed by: Philipp Paulweber
#                 <https://github.com/casm-lang/casm-lang.pkg.docker>
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

FROM alpine

ARG PACKAGE=casm
ARG VERSION=0.1.0

ARG OS=linux
ARG ARCH=x86_64

ARG ARCHIVE=tar.gz
ENV URL=https://github.com/casm-lang/$PACKAGE/releases/download/$VERSION/$PACKAGE-$OS-$ARCH.$ARCHIVE

# 0.1.0 --> "sha256": "6b2dba143753ef3b1e3b42669f4e67baa10a85e95a792f90de79b3a516e552c4"

RUN wget -qO /tmp/$PACKAGE.tar.gz --no-check-certificate $URL \
&&  tar -xvf /tmp/$PACKAGE.tar.gz -C /tmp \
&&  cp   -rf /tmp/$PACKAGE-$VERSION/* /usr/ \
&&  rm   -rf /tmp/$PACKAGE*

RUN casmi --version

CMD ["/bin/bash"]
