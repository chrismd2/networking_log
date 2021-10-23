#!/usr/bin/env bash
# exit on error
set -o errexit

# Initial setup
source .env
mix deps.get --only prod
MIX_ENV=prod mix release

# Compile assets
npm install --prefix ./assets
npm run deploy --prefix ./assets
mix phx.digest


# $(date +"%Y%m%d%H%M")
# Build the release and overwrite the existing release directory
export BUILD_PATH=../electric-journal/
MIX_ENV=prod mix release --overwrite --path $BUILD_PATH
cp $BUILD_PATH/bin/networking_log $BUILD_PATH/bin/networking_log-old
echo '#!/bin/sh' > $BUILD_PATH/bin/networking_log
echo 'set -e' >> $BUILD_PATH/bin/networking_log
cat .env >> $BUILD_PATH/bin/networking_log
sed '1,2d' $BUILD_PATH/bin/networking_log-old >> $BUILD_PATH/bin/networking_log
rm $BUILD_PATH/bin/networking_log-old

# Call migrations in production
# ../electric-journal/bin/networking_log eval "NetworkingLog.Release.migrate"
