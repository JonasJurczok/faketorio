#!/bin/bash

set -ev

luacheck .
busted

if [ ${TRAVIS_BRANCH} = "master" ] && [ ${TRAVIS_TAG} != ""] && [ ${TRAVIS_PULL_REQUEST} = "false" ] ; then
	# we are on master, not in a pull request and we have a tag. Lets deploy
	luarocks --api-key=${api-key}
fi
