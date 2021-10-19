This repository contains Dockerfiles which will install all dependencies needed to build packages for [Dolphin](https://github.com/dolphin-emu/dolphin).

These containers **do not** provide a running version of `Dolphin` or contain the project source in any usable form.

## Building containers
The build is a pretty standard `docker build`, just make sure you explicitly call out a `Dockerfile` with `-f Dockerfile.<distro.version>`:  
```sh
docker build -t dolphin-docker-build:ubuntu20.04 -f Dockerfile.ubuntu20.04 .
```

## Running the containers
Once the `base-image` has been built, the container can be run interactively to build `Dolphin`:  
```sh
docker run -it dolphin-docker-build:ubuntu20.04
```
### The build Script
`build_dolphin.sh` is included in the containers to build `Dolphin` in various ways. Run it with `-h` to see all options.

To build a package for the OS in the current running container: `./build_dolphin.sh -g`

## One-Liner to create packages
This will create `/tmp/dolphin-packages` on your local machine, mount it in the running container, use the build script to create the package, and copy the package to `/tmp/dolphin-packages` for further consumption:  
```sh
mkdir /tmp/dolphin-packages && docker run --rm --mount type=bind,source=/tmp/dolphin-packages,target=/dolphin/packages dolphin-docker-build:ubuntu20.04 /bin/bash -c './build_dolphin.sh -g && cp dolphin/build/*.deb /dolphin/packages'
```
