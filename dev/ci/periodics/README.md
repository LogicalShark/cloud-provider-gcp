# Running perodic tests locally

1.  **Pull the CI Docker Image:**
    ```sh
    docker pull gcr.io/k8s-staging-test-infra/kubekins-e2e:v20260127-f10a7ebcce-master
    ```

2.  **Run an interactive shell inside the container:** (Replace `[your-gcp-project-id]` with your actual GCP project ID)
    ```sh
    docker run -it --rm \
      --entrypoint="" \
      -e GOPATH=/workspace \
      -e GCP_PROJECT="[your-gcp-project-id]" \
      -v "$(pwd):/workspace/src/k8s.io/cloud-provider-gcp" \
      -w /workspace/src/k8s.io/cloud-provider-gcp \
      -v ~/.config/gcloud:/root/.config/gcloud \
      gcr.io/k8s-staging-test-infra/kubekins-e2e:v20260127-f10a7ebcce-master \
      /bin/bash
    ```

3.  **Inside the container, run the desired Kops test script:**

    Run the Kops periodic test scripts:
    ```sh
    ./dev/ci/periodics/run-all-kops-tests.sh
    ```
    For specific test types, replace with `kops-conformance-e2e-tests.sh`, `kops-conformance-gcepd-e2e-tests.sh`, `kops-e2e-latest-with-kubernetes-master.sh`, `kops-e2e-latest.sh`, or `kops-e2e-scenario-kops-simple.sh`.

    These scripts will:
    *   Install `kops`.
    *   Create a GCS bucket for `kops` state if it doesn't exist.
    *   Build the `cloud-controller-manager` (if `make release-tars` is present in the script).
    *   Create a Kubernetes cluster on GCE using `kops`.
    *   Validate the cluster.
    *   Run the specified e2e tests using `go test` and `ginkgo`.
    *   Tear down the cluster automatically.
