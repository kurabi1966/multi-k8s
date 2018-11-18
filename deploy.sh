# Deploy our multi k8s to google cloud kubernetes cluster
# Build project images 
docker build -t kurabi/multi-client:latest -t kurabi/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t kurabi/multi-worker:latest -t kurabi/multi-worker:$SHA -f ./worker/Dockerfile ./worker
docker build -t kurabi/multi-server:latest -t kurabi/multi-server:$SHA -f ./server/Dockerfile ./server

# Push to docker hub
docker push kurabi/multi-client:$latest
docker push kurabi/multi-worker:$latest
docker push kurabi/multi-server:$latest

docker push kurabi/multi-client:$SHA
docker push kurabi/multi-worker:$SHA
docker push kurabi/multi-server:$SHA

# Apply all config in the k8s folder
kubectl apply -f k8s
# Tell kubernetes cluster to update it container with the SHA image tag
kubectl set image deployments/client-deployment client=kurabi/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=kurabi/multi-worker:$SHA
kubectl set image deployments/server-deployment server=kurabi/multi-server:$SHA