#!/usr/bin/env bash
terraform output --json wp_server_map | jq -rc 'keys[]' | while read gcpZone; do
    # For each server
    terraform output --json wp_server_map | jq -rc "values[\"$gcpZone\"][]" | while read serverName; do
        echo "Uploading files to server [$serverName] in zone [$gcpZone]"
        until gcloud compute scp --recurse ./files/ $serverName:~/ --zone $gcpZone; do
            echo "Failed trying to upload files to your new google instance... Sleeping and retry in 10 seconds..."
            sleep 10
        done
    done
done
