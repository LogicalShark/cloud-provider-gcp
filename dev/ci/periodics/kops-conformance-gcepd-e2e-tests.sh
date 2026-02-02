#!/usr/bin/env bash

# This script uses kops to bring up a cluster on GCE, runs the e2e
# conformance tests with GCE-PD enabled, and tears it down.

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

source "$(dirname "$0")/common.sh"

# Setup environment for kops
export KOPS_CLUSTER_NAME="e2e-conformance-gcepd-kops.k8s.local"
export KUBECONFIG="${HOME}/.kube/config"

# Create the cluster
kops create cluster \
  --zones="us-central1-a" \
  --cloud="gce" \
  --project="${GCP_PROJECT}" \
  --name="${KOPS_CLUSTER_NAME}" \
  --master-size="e2-standard-2" \
  --node-size="e2-standard-2" \
  --node-count=3 \
  --yes

# Wait for cluster to be ready
kops validate cluster --wait 15m

# Run conformance tests with GCE-PD enabled
go test "${REPO_ROOT}/test/e2e/" \
  --ginkgo.focus="\[Conformance\]" \
  --provider="gce" \
  --kubeconfig="${KUBECONFIG}" \
  --ginkgo.args="--enabled-volume-drivers=gcepd"

# Tear down the cluster
kops delete cluster --name "${KOPS_CLUSTER_NAME}" --yes
