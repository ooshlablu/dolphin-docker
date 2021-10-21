#!/bin/bash -ex
## Pull in /etc/os-release so we can see what we're running on
. /etc/os-release

## Default Vars
GIT_REPOSITORY='https://github.com/dolphin-emu/dolphin.git'

## Function to print the help message
usage() {
  set +x
  echo ""
  echo "Usage: ${0}"
  echo ""
  echo "Optional Arguments:"
  echo "  -b <Git Branch>: Build the specified git branch, tag, or sha"
  echo "  -p <Pull Request #>: Build the specified Github Pull Request number"
  echo "  -g : Generate Packages"
  echo "  -r <Repository URL>: Git repository to pull from"
  echo "  -h : Show this help message"
  exit 1
}

## Set up getopts
while getopts "ab:p:mcgr:Rh" OPTION; do
  case ${OPTION} in
    "b")
      GIT_BRANCH=${OPTARG};;
    "p")
      PULL_REQUEST=${OPTARG};;
    "g")
      GENERATE_PACKAGES=true;;
    "r")
      GIT_REPOSITORY=${OPTARG};;
    "h")
      HELP=true;;
  esac
done

if [ ${HELP} ]; then
  usage
  exit 2
fi

## All the git stuff
git clone ${GIT_REPOSITORY}
cd dolphin
if [ ${PULL_REQUEST} ]; then
  git fetch origin pull/${PULL_REQUEST}/head:pr
  git checkout pr
elif [ ${GIT_BRANCH} ]; then
  git checkout ${GIT_BRANCH}
fi
git submodule update --init --recursive

## Figure out what type of packages we need to generate
PACKAGE_TYPE='TAR'
case ${ID} in
  'fedora')
    PACKAGE_TYPE='RPM';;
  'ubuntu')
    PACKAGE_TYPE='DEB';;
esac

## Build it
mkdir build
cd build
cmake -DCPACK_PACKAGE_CONTACT="ooshlablu's build script" ..
CPU_CORES=$(nproc --all)
make -j${CPU_CORES}
if [ ${GENERATE_PACKAGES} ]; then
  cpack -G ${PACKAGE_TYPE}
fi
cd ..
