#!/usr/bin/env bash

function say {
	echo -e "$@" | sed \
		-e "s/\(\(@\(red\|green\|yellow\|blue\|magenta\|cyan\|white\|reset\|b\|u\)\)\+\)[[]\{2\}\(.*\)[]]\{2\}/\1\4@reset/g" \
		-e "s/@red/$(tput setaf 1)/g"     \
		-e "s/@green/$(tput setaf 2)/g"   \
		-e "s/@yellow/$(tput setaf 3)/g"  \
		-e "s/@blue/$(tput setaf 4)/g"    \
		-e "s/@magenta/$(tput setaf 5)/g" \
		-e "s/@cyan/$(tput setaf 6)/g"    \
		-e "s/@white/$(tput setaf 7)/g"   \
		-e "s/@reset/$(tput sgr0)/g"      \
		-e "s/@b/$(tput bold)/g"          \
		-e "s/@u/$(tput sgr 0 1)/g"
}

externalSrc=""
dockerBuildQuiet="-q"
version="x36.1"
appName="liteide"
imgName="fedora_build_${appName}"

mkdir -p build/RPMS
mkdir -p build/SRPMS

while [[ "$1" == --* ]]; do
  case $1 in
    --verbose-docker-build)
      dockerBuildQuiet=""
    ;;
    --docker-image-name)
      if ! [ "$2" = "" ]; then
        imgName="$2"
        shift
      fi
    ;;
    --external-src)
			externalSrc="--volume `pwd`/build/BUILD:/home/makerpm/rpmbuild/BUILD --volume `pwd`/build/BUILDROOT:/home/makerpm/rpmbuild/BUILDROOT"
		;;
  esac
  shift
done

mkdir -p build/BUILD
mkdir -p build/BUILDROOT
mkdir -p build/RPMS
mkdir -p build/SOURCES
mkdir -p build/SRPMS

specFile="`pwd`/specs/${appName}/${version}/${appName}.spec"
if ! [ -f "${specFile}" ]; then
	say "@b@red[[Missing spec file!]]"
	say "@green[[${specFile}]]"

	exit 1
fi

say "@b@cyan[[Building docker image...]]"
time docker build -t ${imgName} ${dockerBuildQuiet} \
 	--build-arg UID=`id -u` --file Dockerfile .

say "@b@cyan[[Building the application...]]"
docker run --rm -ti ${externalSrc} \
	--volume `pwd`/specs:/home/makerpm/rpmbuild/SPECS:ro \
	--volume `pwd`/build/RPMS:/home/makerpm/rpmbuild/RPMS \
	--volume `pwd`/build/SRPMS:/home/makerpm/rpmbuild/SRPMS \
	${imgName} --version ${version} --appName ${appName}
