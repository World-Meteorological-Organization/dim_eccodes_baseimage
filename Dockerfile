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

# Install dependencies and editors, then clean apt cache
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 python3-pip python3-venv \
        curl vim nano && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Create a Python virtual environment
RUN python3 -m venv /venv

# Add virtual environment to PATH
ENV PATH="/venv/bin:$PATH"

# Upgrade pip and install eccodes without cache
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir eccodes==2.44.0 && \
    python3 -m eccodes selfcheck

# Create symbolic links for eccodes binaries
RUN ln -s /venv/lib/python3.12/site-packages/eccodeslib/bin/* /venv/bin/

CMD ["/bin/bash"]