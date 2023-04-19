#!/usr/bin/env bash

set -eo pipefail

echo "﹥ Running terraform fmt"
terraform fmt .
echo "﹥ Running tflint"
tflint
echo "﹥ Running terraform-docs"
terraform-docs .