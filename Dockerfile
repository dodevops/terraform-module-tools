FROM hashicorp/terraform:latest
ARG TFDOCS_VERSION="v0.16.0"
ARG TFSEC_VERSION="v1.28.4"

# required packages
RUN apk add curl bash unzip coreutils

# tflint
RUN curl -fsL https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# terraform-docs
RUN TF_HW="amd64" && \
    if [ $(uname -m) == "aarch64" ] || [ $(uname -m) == "arm64" ]; then TF_HW="arm64"; fi && \
		curl -fsLo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/$TFDOCS_VERSION/terraform-docs-$TFDOCS_VERSION-linux-${TF_HW}.tar.gz && \
    tar -xzf terraform-docs.tar.gz && \
    chmod +x terraform-docs && \
    mv terraform-docs /usr/local/bin

# tfsec
RUN TF_HW="amd64" && \
    if [ $(uname -m) == "aarch64" ] || [ $(uname -m) == "arm64" ]; then TF_HW="arm64"; fi && \
		curl -fsLo ./tfsec-linux-${TF_HW} https://github.com/aquasecurity/tfsec/releases/download/$TFSEC_VERSION/tfsec-linux-${TF_HW} && \
    curl -fsLo ./tfsec_checksums.txt https://github.com/aquasecurity/tfsec/releases/download/$TFSEC_VERSION/tfsec_checksums.txt && \
    if sha256sum --check --ignore-missing tfsec_checksums.txt; then \
    	mv tfsec-linux-${TF_HW} /usr/local/bin/tfsec; chmod +x /usr/local/bin/tfsec; else \
    	echo "Failed to check tfsec"; exit 1; \
    fi

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY .terraform-docs.yml /.terraform-docs.yml

ENTRYPOINT /entrypoint.sh
WORKDIR /terraform
