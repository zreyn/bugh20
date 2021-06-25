FROM ubuntu:18.04

# install docker and other apt .deb

RUN apt update \
    && apt install -y curl \
      software-properties-common \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y \
      containerd.io \
      docker-ce \
      docker-ce-cli \
      jq \
      python3-pip \
      unzip \
    && rm -rf /var/lib/apt/lists/*

# install terraform
RUN curl https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_linux_amd64.zip --output terraform.zip \
    && unzip terraform.zip \
    && rm terraform.zip \
    && mv terraform /usr/local/bin/terraform

# install aws things
ENV CRYPTOGRAPHY_DONT_BUILD_RUST 1
RUN pip3 install gimme-aws-creds==2.3.5
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && rm awscliv2.zip \
    && ./aws/install

CMD ["bash"]