#!/bin/bash

export = itemIds = $(aws dynamodb scan --table-name dynamodb-table --query "Items[*].[itemId.S]" --output text)

for itemId in $itemIds ;
do
  echo "updating $itemId"
  aws dynamodb update-item \
    --table-name dynamodb-table \
    --key "{\"itemId\":{\"S\":\"${itemId//[$'\t\r\n ']}\"}}"  \
    --update-expression "SET timestamp = :current_time" \
    --expression-attribute-values '{":current_time": {"S": "'`date +%F-%H-%M-%S`'"}}' \
    --return-values UPDATED_NEW     
  echo "completed $itemId"
  echo ""
done
