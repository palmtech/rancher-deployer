#!/bin/sh

# Download the configuration scripts, unpack and remove the temp file
echo ""
echo "-> Downloading Rancher Stack Configurations"
curl -s -L -u "$RANCHER_ACCESS_KEY:$RANCHER_SECRET_KEY" $RANCHER_URL -o config.zip
unzip config.zip
rm config.zip

# Update the build number based on the CIRCLE_BUILD_NUM env variable
sed "s/BUILD_NUMBER: '[0-9]\{2,3\}'/BUILD_NUMBER: '$CIRCLE_BUILD_NUM'/g" -i docker-compose.yml
sed "s/:v[0-9]\{2,3\}/:v$CIRCLE_BUILD_NUM/g" -i docker-compose.yml

# Do Upgrade
echo ""
echo "-> Updating service $RANCHER_SERVICE_NAME on $RANCHER_STACK_NAME"
rancher-compose -p $RANCHER_STACK_NAME up \
    --force-upgrade --confirm-upgrade --pull \
    -d $RANCHER_SERVICE_NAME
