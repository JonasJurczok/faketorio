#!/bin/bash

set -e

luacheck .
busted

echo "Checking where we should deply or not. Tag is ${TRAVIS_TAG}, branch is ${TRAVIS_BRANCH} and pull request is ${TRAVIS_PULL_REQUEST}".
if [ -n "${TRAVIS_TAG}" ] ; then
	# we have a tag. Lets deploy
	echo "Deploying version ${TRAVIS_TAG}"
	sed -e "s/VERSION/${TRAVIS_TAG}/g" rockspec.template > faketorio-${TRAVIS_TAG}-1.rockspec
	luarocks upload faketorio-${TRAVIS_TAG}-1.rockspec --api-key=${api-key}

	rm faketorio-${TRAVIS_TAG}-1.rockspec
fi
