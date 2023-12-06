#!/bin/bash

backup_id=$(date +'%Y%m%d%H%M%S')

# Set the path where you want to store the backup
if [ -z "$BACKUP_DIR" ]; then
  backup_dir="/backups/${backup_id}"
else
  backup_dir="$BACKUP_DIR/${backup_id}"
fi
echo "Using ${backup_dir} as backup directory. Use environment variable BACKUP_DIR to change it."

# Set the name of the backup file
backup_file="portainer_backup_${backup_id}.tar.gz"

# Portainer API URL with a default value of localhost
if [ -z "$PORTAINER_API_URL" ]; then
  portainer_api_url="http://localhost:19443/api"
else
  portainer_api_url="$PORTAINER_API_URL"
fi
echo "Using ${portainer_api_url} as portainer API url. Use environment variable PORTAINER_API_URL to change it."

# Portainer API authentication details
portainer_username="$PORTAINER_USERNAME"
portainer_password="$PORTAINER_PASSWORD"

# Validate the existence of username and password
if [ -z "$portainer_username" ] || [ -z "$portainer_password" ]; then
  echo "Error: Portainer username and password must be provided."
  exit 1
fi

# Create the backup folder
mkdir -p $backup_dir

# Log in to Portainer and get the authentication token
auth_token=$(curl -s -k -H "Content-Type: application/json" -X POST \
  -d '{"Username":"'"$portainer_username"'","Password":"'"$portainer_password"'"}' \
  "$portainer_api_url/auth" | jq -r .jwt)

# Check if authentication was successful
if [ -z "$auth_token" ]; then
  echo "Error: Failed to authenticate with Portainer. Please check your credentials and Portainer URL."
  exit 1
fi

echo "Logged into ${portainer_api_url} using user ${portainer_username}"
echo "Requesting backup"
# Backup all stacks and settings
curl -s -k -H "Authorization: Bearer $auth_token" -X POST \
  "$portainer_api_url/backup" -d '{}' -o "$backup_dir/$backup_file"

# Log out from Portainer
curl -s -k -H "Authorization: Bearer $auth_token" -X POST "$portainer_api_url/auth/logout"

echo "Backup completed successfully: $backup_dir/$backup_file"
