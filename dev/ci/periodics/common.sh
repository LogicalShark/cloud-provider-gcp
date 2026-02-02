#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

export REPO_ROOT=${REPO_ROOT:-$GOPATH/src/k8s.io/cloud-provider-gcp}
cd "$HOME"

export GO111MODULE=on

# Install kops
export KOPS_VERSION="${KOPS_VERSION:-1.28.0}"
if ! command -v kops &> /dev/null || [[ "$(kops version --short)" != "${KOPS_VERSION}" ]]; then
  wget "https://github.com/kubernetes/kops/releases/download/v${KOPS_VERSION}/kops-linux-amd64"
  chmod +x kops-linux-amd64
  mv kops-linux-amd64 /usr/local/bin/kops
fi


# Build cloud-controller-manager
make -C "${REPO_ROOT}" release-tars

# Setup environment for kops
export GCP_PROJECT="${GCP_PROJECT:-maralder-anthos-dev}" # Placeholder for GCP project
export KOPS_STATE_STORE="gs://${GCP_PROJECT}-kops-state"

# Create kops state store
gsutil mb "${KOPS_STATE_STORE}" || echo "State store already exists"

