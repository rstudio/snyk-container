#!/bin/bash

set -exo pipefail

update-alternatives --install /usr/bin/python3 python /usr/bin/python3.10 10

for version in ${PYTHON_VERSIONS//,/ }
do
    # Install Python version
    PYTHON_VERSION=${version} ${SCRIPTS_DIR}/install_python.sh -d -r /tmp/requirements.txt

    # Set as default if applicable
    if [[ ${version} == ${DEFAULT_PYTHON_VERSION} ]]; then
      priority=2
      ln -sf /opt/python/${version} /opt/python/default
    else
      priority=1
    fi

    # Create PATH symlinks for python3.x and pip3.x
    ln -sf /opt/python/${version}/bin/python3 /usr/local/bin/python${version%\.*}
    ln -sf /opt/python/${version}/bin/pip3 /usr/local/bin/pip${version%\.*}
    update-alternatives --install /usr/bin/python3 python /opt/python/${version}/bin/python3 ${priority}

    # Install Jupyter kernel
    /opt/python/${version}/bin/python3 -m pip install ipykernel
    /opt/python/${version}/bin/python3 -m ipykernel install --name "py${version%\.*}" --display-name "Python ${version%\.*}"
done

# Shim default Python installation to /etc/profile.d
# Reference: https://docs.posit.co/ide/server-pro/python/configuring_default.html
echo "PATH=/opt/python/default/bin:\$PATH" >> /etc/profile.d/python.sh
chmod +x /etc/profile.d/python.sh
