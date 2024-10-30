#!/bin/bash

# Environment variables
SITE_NAME=${SITE_NAME:-grierpnext.local}
DB_NAME=${DB_NAME:-grierpnext}
DB_PASSWORD=${DB_PASSWORD:-oUtuSgbsRrHGYO4!}
DB_HOST=${DB_HOST:-grierpnextdb.mysql.database.azure.com}
DB_PORT=${DB_PORT:-3306}
REDIS_CACHE=${REDIS_CACHE:-redis://grierp-redis.redis.cache.windows.net:6379}
REDIS_QUEUE=${REDIS_QUEUE:-redis://grierp-redis.redis.cache.windows.net:6379}
REDIS_SOCKETIO=${REDIS_SOCKETIO:-redis://grierp-redis.redis.cache.windows.net:6379}

# Wait for database to be reachable (optional, if needed)
# You can uncomment and modify the line below if the database is hosted remotely and may take time to connect.
# wait-for-it $DB_HOST:$DB_PORT -t 60

# Check if the site already exists to avoid re-creation
if [ ! -d "/home/frappe/frappe-bench/sites/$SITE_NAME" ]; then
    cd /home/frappe/frappe-bench
    bench new-site $SITE_NAME \
        --db-name $DB_NAME \
        --db-password $DB_PASSWORD \
        --admin-password admin \
        --mariadb-root-password $DB_PASSWORD
    # Set site configuration
    bench set-config -c /home/frappe/frappe-bench/sites/$SITE_NAME/site_config.json db_type "mysql"
    bench set-config -c /home/frappe/frappe-bench/sites/$SITE_NAME/site_config.json db_host "$DB_HOST"
    bench set-config -c /home/frappe/frappe-bench/sites/$SITE_NAME/site_config.json db_port "$DB_PORT"
    bench set-config -c /home/frappe/frappe-bench/sites/$SITE_NAME/site_config.json redis_cache "$REDIS_CACHE"
    bench set-config -c /home/frappe/frappe-bench/sites/$SITE_NAME/site_config.json redis_queue "$REDIS_QUEUE"
    bench set-config -c /home/frappe/frappe-bench/sites/$SITE_NAME/site_config.json redis_socketio "$REDIS_SOCKETIO"
fi

# Start Gunicorn as the final command
exec "$@"
