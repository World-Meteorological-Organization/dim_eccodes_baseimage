###############################################################################
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
###############################################################################

FROM ubuntu:noble

ARG ECCODES_VER=2.44.0

# Install dependencies and editors, apply security updates, then clean apt cache
RUN apt-get update && \
    apt-get upgrade -y --fix-missing && \
    apt-get install -y --no-install-recommends \
        python3 python3-pip python3-venv \
        curl vim nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Create a Python virtual environment with access to system site packages
RUN python3 -m venv /venv --system-site-packages

# Add virtual environment to PATH
ENV PATH="/venv/bin:$PATH" \
    ECCODES_DEFINITION_PATH="/venv/share/eccodes/definitions"

# Upgrade pip and install eccodes without cache
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir eccodes==${ECCODES_VER} && \
    python3 -m eccodes selfcheck

# Create symbolic links for eccodes binaries
RUN ln -s /venv/lib/python3.12/site-packages/eccodeslib/bin/* /venv/bin/

# get definitions and move to correct location, then clean up
RUN cd /tmp && curl -L -o eccodes.tar.gz https://github.com/ecmwf/eccodes/archive/refs/tags/${ECCODES_VER}.tar.gz && \
    tar -xzf eccodes.tar.gz && \
    mkdir -p /venv/share/eccodes && \
    mv eccodes-${ECCODES_VER}/definitions /venv/share/eccodes/ && \
    rm -rf /tmp/eccodes*

CMD ["/bin/bash"]
