# Build script for the LiteIDE X IDE

Docker-based LiteIDE X RPM builder for Fedora

Simply run `./build.sh` :) it will eventually generate the rpm and srpm files in the `build/RPMS` and `build/SRPMS` folders

## Details

This script uses Docker to build the LiteIDE X IDE for Fedora. Actually it runs
in a Fedora 28 image, but can be easily changed in the first line of the Dockerfile.

## build.sh options

- `--verbose-docker-build` show the Docker image build process
- `--docker-image-name <name>` overwrite the default docker image name (`fedora_build_liteide`)
- `--external-src` mount a local build volume (useful to test builds without recompiling everything all the times)

