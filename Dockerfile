FROM alpine:latest

RUN apk add --no-cache curl jq

WORKDIR /app

# Copy the backup script into the container
COPY backup.sh .
RUN chmod +x backup.sh

ENV CRON_SCHEDULE="0 */6 * * *"
RUN echo "$CRON_SCHEDULE \"sh /app/backup.sh\"" > /etc/crontabs/root

CMD ["crond", "-f"]
