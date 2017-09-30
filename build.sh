#!/bin/bash

set -e

luacheck .
busted

if [ "${TRAVIS_BRANCH}" = "master" ] && [ -n "${TRAVIS_TAG}" ] && [ "${TRAVIS_PULL_REQUEST}" = "false" ] ; then
	# we are on master, not in a pull request and we have a tag. Lets deploy
	sed -e "s/VERSION/${TRAVIS_TAG}/g" rockspec.template > faketorio-${TRAVIS_TAG}-1.rockspec
	luarocks upload faketorio-${TRAVIS_TAG}-1.rockspec --api-key=${api-key}

	rm faketorio-${TRAVIS_TAG}-1.rockspec
fi
