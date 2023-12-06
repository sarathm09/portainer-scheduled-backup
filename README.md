# portainer-scheduled-backup
Backup your portainer instances periodically using this script/docker image.


## Building locally


```sh
docker build -t portainer-scheduled-backup .
```

```sh
docker run -d \
  --name portainer-scheduled-backup \
  -e BACKUP_DIR="/path/to/backup" \
  -e PORTAINER_USERNAME="your_username" \
  -e PORTAINER_PASSWORD="your_password" \
  -e PORTAINER_API_URL="http://your-portainer-host/api" \
  -e CRON_SCHEDULE="0 */6 * * *" \
  portainer-scheduled-backup
```

