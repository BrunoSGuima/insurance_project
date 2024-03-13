#!/bin/bash

docker network create rabbitmq_network
# Start first application
echo "Starting insurance_policies_graphql_application..."
cd ./insurance_policies_graphql
docker compose up -d

# Start web application
echo "Starting insurance_policies_web_application..."
cd ../insurance_policies_web
docker compose up -d

# Start second application
echo "Starting insurance_policies_api_application..."
cd ../insurance_policies_api 
docker compose up -d

echo 'Waiting for rabbitmq to start...'
# await for rabbitmq to start
sleep 10
docker exec -it secondapp bash -c "rails runner 'BunnyConnection.connection'"

