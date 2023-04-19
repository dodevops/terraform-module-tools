# terraform module tools

This repository contains an image that is used for our own terraform modules to validate and format the modules.

Included is:

- [Terraform](https://www.terraform.io/) (for terraform fmt)
- [Tflint](https://github.com/terraform-linters/tflint)
- [terraform-docs](https://github.com/terraform-docs/terraform-docs)

# Usage

Run the tools by calling

    docker run -v "$PWD":/terraform ghcr.io/dodevops/terraform-module-tools:latest 