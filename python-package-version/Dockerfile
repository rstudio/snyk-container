FROM docker.io/rstudio/rstudio-workbench:ubuntu2204-2024.09.0-375.pro3

ARG DEBIAN_FRONTEND=noninteractive
ARG DEFAULT_PYTHON_VERSION="3.11.7"
ARG PYTHON_VERSIONS="3.11.7,3.10.14,3.9.19,3.8.19"
ARG SCRIPTS_DIR=/opt/positscripts

COPY dependencies/install_multi_python.sh /tmp/install_multi_python.sh
COPY dependencies/requirements.txt /tmp/requirements.txt
RUN rm -f /opt/python/default \
    && /tmp/install_multi_python.sh \
    && ln -s /opt/python/default/bin/snow /usr/local/bin/snow \
    && rm -f /tmp/install_multi_python.sh /tmp/requirements.txt

