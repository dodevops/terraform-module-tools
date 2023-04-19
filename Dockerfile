FROM hashicorp/terraform:latest
ARG TFDOCS_VERSION="v0.16.0"

# required packages
RUN apk add curl bash unzip

# tflint
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# terraform-docs
RUN TF_HW="amd64" && \
    if [ $(uname -m) == "aarch64" ] || [ $(uname -m) == "arm64" ]; then TF_HW="arm64"; fi && \
		curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/$TFDOCS_VERSION/terraform-docs-$TFDOCS_VERSION-linux-${TF_HW}.tar.gz && \
    tar -xzf terraform-docs.tar.gz && \
    chmod +x terraform-docs && \
    mv terraform-docs /usr/local/bin

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY .terraform-docs.yml /.terraform-docs.yml

ENTRYPOINT /entrypoint.sh
WORKDIR /terraform
