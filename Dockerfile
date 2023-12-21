# Copyright 2024 Mateusz Urbanek.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#########################################################################################
# Build
#########################################################################################

# First stage: building the driver executable.
FROM docker.io/library/rust:1.75.0 AS builder

# Set the working directory.
WORKDIR /work

# Copy the Cargo manifests.
COPY Cargo.toml Cargo.toml
COPY Cargo.lock Cargo.lock

# Copy the  source.
COPY src src

# Build.
RUN cargo build --release

#########################################################################################
# Runtime
#########################################################################################

# Second stage: building final environment for running the executable.
FROM docker.io/library/debian:stable-slim AS runtime

# Copy the executable.
COPY --from=builder --chown=65532:65532 /work/target/release/metapod /usr/bin/metapod

# Set the final UID:GID to non-root user.
USER 65532:65532

# Disable healthcheck.
HEALTHCHECK NONE

# Add labels
LABEL name="metapod"
LABEL description="Metapod - a metadata controller for Kubernetes"
LABEL license="Apache-2.0"
LABEL maintainers="Mateusz Urbanek <mateusz.urbanek.98@gmail.com>"

# Set the entrypoint.
ENTRYPOINT [ "/usr/bin/metapod" ]
CMD []
