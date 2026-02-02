#!/usr/bin/env bash

# This script uses kops to bring up a cluster on GCE, runs the full e2e
# tests, and tears it down.

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

source "$(dirname "$0")/common.sh"

# Setup environment for kops
export KOPS_CLUSTER_NAME="e2e-full-kops.k8s.local"
export KUBECONFIG="${HOME}/.kube/config"

# Create the cluster
kops create cluster \
  --zones="us-central1-a,us-central1-b" \
  --cloud="gce" \
  --project="${GCP_PROJECT}" \
  --name="${KOPS_CLUSTER_NAME}" \
  --master-size="e2-standard-8" \
  --node-size="e2-standard-4" \
  --node-count=3 \
  --yes

# Wait for cluster to be ready
kops validate cluster --wait 15m

# Run e2e tests with parallelization and skip regex
go test "${REPO_ROOT}/test/e2e/" \
  --ginkgo.flakeAttempts=2 \
  --ginkgo.parallel=30 \
  --ginkgo.skip="\[Slow\]|\[Serial\]|\[Disruptive\]|\[Flaky\]|\[Feature:.+\]" \
  --provider="gce" \
  --kubeconfig="${KUBECONFIG}" \
  --ginkgo.args="--minStartupPods=8"

# Tear down the cluster
kops delete cluster --name "${KOPS_CLUSTER_NAME}" --yes
