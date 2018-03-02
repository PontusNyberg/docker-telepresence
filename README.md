# docker-telepresence
Created from docker:dind 
Added kubectl and telepresence 

Made for Windows, running minikube and kubectl
This container counts minikube and kubtctl to be installed under C:\Users\<Username>\

Entrypoint is starting the docker daemon and builds a Dockerfile that have been mounted in /app.
We copy the mounted kube-config to not mess with the local one, change it to fit the container paths.
Setting the kubeconfig-env to the newly changed kube-config.
Using telepresence to swap the deployment to our local one.


To run the container
```
docker run --name <container-name> -ti -d --privileged -v <Local folder for APP>:/app \
  -v $USERPROFILE/.kube/config:/kube-config -v $USERPROFILE/.minikube:/minikube \
  -e USERPROFILE=$USERPROFILE -e DEPLOYMENTNAME=<Deployment name in cluster> \
  docker-telepresence
```