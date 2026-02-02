#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

SCRIPT_DIR="$(dirname "$0")"

"${SCRIPT_DIR}/kops-conformance-e2e-tests.sh"
"${SCRIPT_DIR}/kops-conformance-gcepd-e2e-tests.sh"
"${SCRIPT_DIR}/kops-e2e-latest-with-gcepd.sh"
"${SCRIPT_DIR}/kops-e2e-latest-with-kubernetes-master.sh"
"${SCRIPT_DIR}/kops-e2e-latest.sh"
"${SCRIPT_DIR}/kops-e2e-scenario-kops-simple.sh"
