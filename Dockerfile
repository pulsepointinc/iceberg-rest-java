#
# Copyright 2024 Tabular Technologies Inc.
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

FROM debian:12 AS builder

RUN --mount=type=cache,id=apt1,target=/var/cache/apt \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        openjdk-17-jdk

COPY --link gradle /app/gradle
COPY --link gradlew build.gradle settings.gradle /app
COPY --link src /app/src
WORKDIR /app/

RUN --mount=type=cache,target=/root/.gradle \
  ./gradlew --no-daemon build shadowJar

FROM debian:12

RUN --mount=type=cache,id=apt2,target=/var/cache/apt \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        openjdk-17-jre-headless \
        krb5-user

RUN \
    set -xeu && \
    groupadd iceberg --gid 1000 && \
    useradd iceberg --uid 1000 --gid 1000 --create-home

COPY --from=builder --chown=iceberg:iceberg \
    /app/build/libs/iceberg-rest-image-all.jar /home/iceberg/iceberg-rest-image-all.jar

COPY --link --chown=iceberg:iceberg \
    refresh.sh /home/iceberg/refresh.sh

ENV REST_PORT=8181
EXPOSE $REST_PORT

USER iceberg:iceberg
ENV LANG=en_US.UTF-8
WORKDIR /home/iceberg
CMD ["java", "-jar", "iceberg-rest-image-all.jar"]
