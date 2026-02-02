#!/usr/bin/env bash

# This script uses kops to bring up a simple cluster on GCE, runs the kops-simple scenario,
# and tears it down.

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

source "$(dirname "$0")/common.sh"

# Setup environment for kops
export KOPS_CLUSTER_NAME="e2e-kops-simple.k8s.local"
export KUBECONFIG="${HOME}/.kube/config"

# Create the cluster
kops create cluster \
  --zones="us-central1-a" \
  --cloud="gce" \
  --project="${GCP_PROJECT}" \
  --name="${KOPS_CLUSTER_NAME}" \
  --master-size="e2-standard-2" \
  --node-size="e2-standard-2" \
  --node-count=1 \
  --yes

# Wait for cluster to be ready
kops validate cluster --wait 10m

# Run the kops-simple scenario (assuming it's a test script that takes kubeconfig)
"${REPO_ROOT}/e2e/scenarios/kops-simple" --kubeconfig="${KUBECONFIG}"

# Tear down the cluster
kops delete cluster --name "${KOPS_CLUSTER_NAME}" --yes
