# Python Package Version with Four Segments

This archive contains an example Dockerfile and associated files to recreate an issue scanning

## Requirements

- [Docker](https://docs.docker.com/engine/install/)
- [Snyk CLI](https://docs.snyk.io/snyk-cli/install-or-update-the-snyk-cli)
- [Just](https://just.systems/man/en/chapter_5.html)

## Usage

The image can be built using the following command from within this directory. Alternatively, the `docker buildx build` command could be called manually using similar options to those located in the `justfile`.
```bash
just build
```

The failing Snyk test command can then be triggered using the following command. Alternatively, the `snyk container test` command could be called manually using similar options to those located in the `justfile`.
```bash
just snyk-test
```

Example expected output is in the next section below.

The Dockerfile in this archive references one of Posit's upstream Docker images, [Workbench](https://github.com/rstudio/rstudio-docker-products/blob/dev/workbench/Dockerfile.ubuntu2204), as a base image. Workbench utilizes another couple base images, [product-base-pro](https://github.com/rstudio/rstudio-docker-products/blob/dev/product/pro/Dockerfile.ubuntu2204) and [product-base](https://github.com/rstudio/rstudio-docker-products/blob/dev/product/base/Dockerfile.ubuntu2204). The Dockerfile directly utilizes a script included in product-base, [install_python.sh](https://github.com/rstudio/rstudio-docker-products/blob/dev/product/base/scripts/ubuntu/install_python.sh). These images and files are publicly available and could help aid in further investigation of a root cause.

## Original Error Output

```bash
$ just build
docker buildx build -f /home/ianp/Documents/snyk-85535/Dockerfile -t "rstudio/rstudio-workbench-snyk-85535:latest" --load .
[+] Building 619.5s (10/10) FINISHED                                                                                                                                                                                         docker-container:posit-builder
 => [internal] load build definition from Dockerfile                                                                                                                                                                                                   0.0s
 => => transferring dockerfile: 595B                                                                                                                                                                                                                   0.0s
 => [internal] load metadata for docker.io/rstudio/rstudio-workbench:ubuntu2204-2024.04.2-764.pro1                                                                                                                                                     1.2s
 => [internal] load .dockerignore                                                                                                                                                                                                                      0.0s
 => => transferring context: 2B                                                                                                                                                                                                                        0.0s
 => [1/4] FROM docker.io/rstudio/rstudio-workbench:ubuntu2204-2024.04.2-764.pro1@sha256:38660f9b5083a726af149eba0d2219f629e2132b57387443507fb5383aa780e0                                                                                               0.0s
 => => resolve docker.io/rstudio/rstudio-workbench:ubuntu2204-2024.04.2-764.pro1@sha256:38660f9b5083a726af149eba0d2219f629e2132b57387443507fb5383aa780e0                                                                                               0.0s
 => [internal] load build context                                                                                                                                                                                                                      0.0s
 => => transferring context: 1.56kB                                                                                                                                                                                                                    0.0s
 => CACHED [2/4] COPY dependencies/install_multi_python.sh /tmp/install_multi_python.sh                                                                                                                                                                0.0s
 => CACHED [3/4] COPY dependencies/requirements.txt /tmp/requirements.txt                                                                                                                                                                              0.0s
 => [4/4] RUN rm -f /opt/python/default     && /tmp/install_multi_python.sh     && ln -s /opt/python/default/bin/snow /usr/local/bin/snow     && rm -f /tmp/install_multi_python.sh /tmp/requirements.txt                                            452.9s
 => exporting to oci image format                                                                                                                                                                                                                    164.7s
 => => exporting layers                                                                                                                                                                                                                              109.9s
 => => exporting manifest sha256:1a360b798fc494c0064ecd0e5186f8115eb70cc816fca228b2d6fd6daedecffc                                                                                                                                                      0.0s
 => => exporting config sha256:5630b128cbc3db0e794aa692ce17da2fb76256bf44eebc1d74c014b92560760e                                                                                                                                                        0.0s
 => => sending tarball                                                                                                                                                                                                                                54.8s
 => importing to docker                                                                                                                                                                                                                                0.0s
$ just snyk-test
snyk container test --exclude-base-image-vulns --file="/home/ianp/Documents/snyk-85535/Dockerfile" --format="legacy" --org="REDACTED" --platform="linux/amd64" --severity-threshold="high" rstudio/rstudio-workbench-snyk-85535:latest
Invalid Version: 71.1.0.20240726
error: Recipe `snyk-test` failed on line 9 with exit code 2
```
