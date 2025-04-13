FROM deepnote/python:3.10

ENV NODE_VERSION=18.16.0
ENV NVM_DIR=/opt/nvm
RUN mkdir $NVM_DIR

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.39.3/install.sh | bash
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="${NVM_DIR}/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

# Installing tslab is problematic as root
RUN useradd -ms /bin/bash tslab-installer
RUN chmod -R 777 /opt/nvm
RUN sudo -u tslab-installer sh -c ' \
    export NVM_DIR=/opt/nvm; \
    . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}; \
    . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}; \
    . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}; \
    PATH="/opt/nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"; \
    /opt/nvm/versions/node/v18.16.0/bin/npm i -g tslab'

RUN pip install jupyter
RUN tslab install

ENV NODE_PATH "${NVM_DIR}/versions/node/v${NODE_VERSION}/lib/node_modules"
ENV DEFAULT_KERNEL_NAME "tslab"
