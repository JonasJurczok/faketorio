#!/bin/bash

set -e

luacheck .
busted


echo "Checking for branch and pull request state. Branch is ${TRAVIS_BRANCH}, pull request is ${TRAVIS_PULL_REQUEST}".
if [ "${TRAVIS_BRANCH}" = "master" ] && [ "${TRAVIS_PULL_REQUEST}" = "false" ] ; then
	# we are on master, not in a pull request and we have a tag. Lets deploy
	version=$(git tag | sort | head -n 1)
	echo "Deploying version ${version}"
	sed -e "s/VERSION/${version}/g" rockspec.template > faketorio-${version}-1.rockspec
	luarocks upload faketorio-${version}-1.rockspec --api-key=${api-key}

	rm faketorio-${version}-1.rockspec
fi
