export BACKEND_SVC_NAME=summarizer-requests-processor
export RESOURCE_GROUP=rg-aca-dapr-techsummit

az containerapp secret set \
--name $BACKEND_SVC_NAME \
--resource-group $RESOURCE_GROUP \
--secrets "svcbus-connstring=Endpoint=sb://sb-dev-frc-summarizer-00.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=37xjPSmJJd/7s0ixdU3Q9AWW0UyX8BxN5+ASbDTnohQ="

export TIMESTAMP=$(date +%s)

az containerapp update \
--name $BACKEND_SVC_NAME \
--resource-group $RESOURCE_GROUP \
--min-replicas 1 \
--max-replicas 30 \
--revision-suffix r$TIMESTAMP \
--set-env-vars "SendGrid__IntegrationEnabled=false" \
--scale-rule-name "topic-msgs-length" \
--scale-rule-type "azure-servicebus" \
--scale-rule-auth "connection=svcbus-connstring" \
--scale-rule-metadata "topicName=link-to-summarize" \
                        "subscriptionName=summarizer-requests-processor" \
                        "namespace=sb-dev-frc-summarizer-00" \
                        "messageCount=5" \
                        "connectionFromEnv=svcbus-connstring"

# az containerapp replica list \
# --name $BACKEND_SVC_NAME \
# --resource-group $RESOURCE_GROUP \
# --query [].name