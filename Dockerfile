FROM stellar/base:latest

LABEL Maintainer="Bryce Budd <bbudd@liquidhub.com>"

ENV STELLAR_CORE_VERSION 9.2.0-551-7561c1d5
ENV HORIZON_VERSION 0.12.3
ENV BRIDGE_VERSION 0.0.30
ENV COMPLIANCE_VERSION 0.0.30
ENV NVM_DIR /usr/local/nvm
ENV NVM_VERSION 0.33.9
ENV NODE_VERSION 8.11.1

EXPOSE 5432
EXPOSE 8000
EXPOSE 11625
EXPOSE 11626
EXPOSE 8007
EXPOSE 8006

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ADD dependencies /
RUN ["chmod", "+x", "dependencies"]
RUN /dependencies

ADD install /
RUN ["chmod", "+x", "install"]
RUN /install

RUN ["mkdir", "-p", "/opt/stellar"]
RUN ["touch", "/opt/stellar/.docker-ephemeral"]

RUN useradd --uid 10011001 --home-dir /home/stellar --no-log-init stellar \
    && mkdir -p /home/stellar \
    && chown -R stellar:stellar /home/stellar

RUN ["ln", "-s", "/opt/stellar", "/stellar"]
RUN ["ln", "-s", "/opt/stellar/core/etc/stellar-core.cfg", "/stellar-core.cfg"]
RUN ["ln", "-s", "/opt/stellar/horizon/etc/horizon.env", "/horizon.env"]
RUN ["ln", "-s", "/opt/stellar/bridge/etc/bridge.cfg", "/bridge.cfg"]
RUN ["ln", "-s", "/opt/stellar/compliance/etc/compliance.cfg", "/compliance.cfg"]
ADD common /opt/stellar-default/common
ADD pubnet /opt/stellar-default/pubnet
ADD testnet /opt/stellar-default/testnet
ADD standalone /opt/stellar-default/standalone
ADD bank0 /opt/stellar-default/bank0
ADD bank1 /opt/stellar-default/bank1
ADD bank2 /opt/stellar-default/bank2


# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && source $NVM_DIR/bash_completion \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

ADD start /
RUN ["chmod", "+x", "start"]

ENTRYPOINT ["/init", "--", "/start" ]
