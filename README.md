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
docker run -it performous-docker-build:ubuntu20.04
```
## The build Script
`build_dolphin.sh` is included in the containers to build `Dolphin` in various ways. Run it with `-h` to see all options.

To build a package for the OS in the current running container: `./build_dolphin.sh -g`
