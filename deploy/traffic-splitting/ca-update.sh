export REGISTRY=crdevweusummarizer00.azurecr.io
export RESOURCE_GROUP=rg-aca-dapr-techsummit
export TIMESTAMP=$(date +%s)
export IMAGE=$REGISTRY/summarizer/frontend:$TIMESTAMP

echo "Using timestamp: $TIMESTAMP"
echo "Using image: $IMAGE"

docker build -t $REGISTRY/summarizer/frontend:$TIMESTAMP  ../../src/frontend
docker push $REGISTRY/summarizer/frontend:$TIMESTAMP

az containerapp update -n summarizer-frontend  -g rg-aca-dapr-techsummit \
    --image $REGISTRY/summarizer/frontend:$TIMESTAMP