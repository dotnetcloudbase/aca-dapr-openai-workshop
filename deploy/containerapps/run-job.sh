export RESOURCE_GROUP=rg-temp-dev-00
export CONTAINER_APPS_ENVIRONMENT="cae-dev-weu-temp-00"
export REGISTRY="crdevweutemp00.azurecr.io"

# export d="PUBSUB_REQUESTS_NAME=summarizer-pubsub \
#                 PUBSUB_REQUESTS_TOPIC=link-to-summarize \
#                 JOB_REQUESTOR_EMAIL=me@contoso.com \
#                 JOB_REQUESTED_URLS=https://fr.wikipedia.org/wiki/Architecture_hexagonale,\
# https://fr.wikipedia.org/wiki/Domain-driven_design,\
# https://fr.wikipedia.org/wiki/Programmation_orient%C3%A9e_objet,\
# https://fr.wikipedia.org/wiki/Programmation_r%C3%A9active"

echo "Creating summary link requests ..."
# See: https://learn.microsoft.com/en-us/cli/azure/containerapp/job?view=azure-cli-latest

az containerapp job create \
    --name "create-summary-link-requests" --resource-group $RESOURCE_GROUP  --environment $CONTAINER_APPS_ENVIRONMENT \
    --trigger-type "Manual" \
    --replica-timeout 60 --replica-retry-limit 1 --replica-completion-count 1 --parallelism 1 \
    --image "$REGISTRY/summarizer/job:latest" \
    --cpu "0.25" --memory "0.5Gi" \
    --env-vars "PUBSUB_REQUESTS_NAME=summarizer-pubsub" \
                "PUBSUB_REQUESTS_TOPIC=link-to-summarize" \
                "JOB_REQUESTOR_EMAIL=me@contoso.com" \
                "JOB_REQUESTED_URLS=https://fr.wikipedia.org/wiki/Architecture_hexagonale,\
https://fr.wikipedia.org/wiki/Domain-driven_design,\
https://fr.wikipedia.org/wiki/Programmation_orient%C3%A9e_objet,\
https://fr.wikipedia.org/wiki/Programmation_r%C3%A9active"


az containerapp job start   -n create-summary-link-requests \
                            -g rg-temp-dev-00 --image $REGISTRY/summarizer/job:latest \
                            --cpu "0.25" --memory "0.5Gi" \
                            --registry-identity /subscriptions/f6f44694-cda4-466c-89f5-06780bf7c44d/resourceGroups/rg-temp-dev-00/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-kv-dev-weu-temp-00 \
                            --env-vars "PUBSUB_REQUESTS_NAME=summarizer-pubsub" \
                                        "PUBSUB_REQUESTS_TOPIC=link-to-summarize" \
                                        "JOB_REQUESTOR_EMAIL=me@contoso.com" \
                                        "JOB_REQUESTED_URLS=https://fr.wikipedia.org/wiki/Architecture_hexagonale,\
https://fr.wikipedia.org/wiki/Domain-driven_design,\
https://fr.wikipedia.org/wiki/Programmation_orient%C3%A9e_objet,\
https://fr.wikipedia.org/wiki/Programmation_r%C3%A9active"



az containerapp job start -n create-summary -g rg-temp-dev-00 --image MyImageName --cpu 0.5 --memory 1.0Gi

az containerapp job start [--args]
                          [--command]
                          [--container-name]
                          [--cpu]
                          [--env-vars]
                          [--ids]
                          [--image]
                          [--memory]
                          [--name]
                          [--no-wait]
                          [--registry-identity]
                          [--resource-group]
                          [--subscription]


# az containerapp job delete -n create-summary-link-requests -g rg-temp-dev-00
# az containerapp job show -n create-summary-link-requests -g rg-temp-dev-00
# az containerapp job list -g rg-temp-dev-00
# az containerapp job execution list -n create-summary-link-requests -g rg-temp-dev-00
# az containerapp logs show -n "create-summary-link-requests" -g "rg-temp-dev-00"
# az containerapp job execution show --job-execution-name create-summary-link-requests --name create-summary-link-requests --resource-group rg-temp-dev-00