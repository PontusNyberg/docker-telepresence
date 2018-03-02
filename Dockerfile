FROM docker:dind

# Install kubectl
RUN apk add --no-cache curl \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x /kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# Install telepresence
RUN apk add --no-cache python3 openssh-client iptables tini conntrack-tools git torsocks sshfs socat sudo \
    && pip3 install git+https://github.com/datawire/sshuttle.git@telepresence
RUN git clone https://github.com/datawire/telepresence.git \
    && mkdir -p /tmp/build/ \
    && mv telepresence/setup.py /tmp/build/ \
    && cp -Rf telepresence/telepresence/ /tmp/build/ \
    && cp telepresence/local-docker/entrypoint.py /usr/bin/ \
    && pip3 install /tmp/build && chmod +x /usr/bin/entrypoint.py \
    && apk del --no-cache -r git curl \
    && rm -Rf /telepresence

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["sh","entrypoint.sh"]