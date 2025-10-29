# https://developer.hashicorp.com/terraform/cloud-docs/agents/agents#customize-the-agent-docker-image
FROM hashicorp/tfc-agent:latest

USER root

# Install sudo. The container runs as a non-root user, but people may rely on
# the ability to apt-get install things.
RUN apt-get -y install sudo

# Permit tfc-agent to use sudo apt-get commands.
RUN echo 'tfc-agent ALL=NOPASSWD: /usr/bin/apt-get , /usr/bin/apt' >> /etc/sudoers.d/50-tfc-agent


RUN apt-get update && \
apt-get install -y curl && \
curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
apt-get install -y nodejs && \
npm install -g npm@latest && \
apt-get clean && rm -rf /var/lib/apt/lists/*
USER tfc-agent

CMD [ "npm", "--version" ]
