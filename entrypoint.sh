#!/bin/sh
# Start the docker daemon
dockerd-entrypoint.sh &

# Build the app we are going to develop
docker build -t app /app/

# Copy the config and change the paths to suit the container
cp /kube-config /.kubeconfig
export USERPROFILE=$(echo $USERPROFILE | sed 's/\\/\\\\/g' | sed 's/:/\\\:/g')
sed -i 's/'$USERPROFILE'\\.minikube\\/\/minikube\//g' .kubeconfig
# Set the correct path for kubeconfig
export KUBECONFIG=/.kubeconfig

# We swap the current running kush-ui to our own container
# and volume in our files so that we are able to work with 
# live reload.
# This is sadly only made for Kush-UI.
# TODO: Find a general solution to volume in all the necessary files 
# for a project. (we cannot volume in the whole /app folder becase
# npm is complaining that we do not use the same file system)
cd /app && \
telepresence --swap-deployment $DEPLOYMENTNAME --docker-run --rm -it \
 -v /app/src/app:/usr/src/app/src/app \
 -v /app/config:/usr/src/app/config \
 -v /app/.bowerrc:/usr/src/app/.bowerrc \
 -v /app/.csslintrc:/usr/src/app/.csslintrc \
 -v /app/.jshintignore:/usr/src/app/.jshintignore \
 -v /app/.jshintrc:/usr/src/app/.jshintrc \
 -v /app/.jscsrc:/usr/src/app/.jscsrc \
 -v /app/.jsbeautifyrc:/usr/src/app/.jsbeautifyrc \
 app sh -c 'gulp serve'