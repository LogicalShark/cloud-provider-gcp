# cloud-provider-gcp

## Publishing cloud-controller-manager image

Environment variables `IMAGE_REGISTRY`, `IMAGE_REPO` and `IMAGE_TAG` can be
used to override destination GCR repository and tag.

You can run push-images tool. The tool is built from ko, for example this command pushes image to Google Artifact Registry under project `my-project` and existing repository `my-repo`:

```sh
IMAGE_REPO=us-central1-docker.pkg.dev/my-project/my-repo IMAGE_TAG=v0 ./tools/push-images
```

# Cross-compiling

Selecting the target platform is done with the `--platforms` option with `bazel`.
This command builds release tarballs for Windows:

```sh
bazel build --platforms=@io_bazel_rules_go//go/toolchain:windows_amd64 //release:release-tars
```

This command explicitly targets Linux as the target platform:

```sh
bazel build --platforms=@io_bazel_rules_go//go/toolchain:linux_amd64 //release:release-tars
```


# Dependency management

Dependencies are managed using [Go modules](https://github.com/golang/go/wiki/Modules) (`go mod` subcommands).

## Working within GOPATH

If you work within `GOPATH`, `go mod` will error out unless you do one of:

- move repo outside of GOPATH (it should "just work")
- set env var `GO111MODULE=on`

## Add a new dependency

```sh
go get github.com/new/dependency && ./tools/update_vendor.sh
```

## Update an existing dependency

```sh
go get -u github.com/existing/dependency && ./tools/update_vendor.sh
```

## Update all dependencies

```sh
go get -u && ./tools/update_vendor.sh
```

Note that this most likely won't work due to cross-dependency issues or repos
not implementing modules correctly.
