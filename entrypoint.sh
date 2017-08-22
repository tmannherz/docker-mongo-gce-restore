#!/bin/bash
set -e

RESTORE_DIR=/restore
gs_project_id="$GS_PROJECT_ID"
gs_service_client_id="$GS_SERVICE_EMAIL"

# Create boto config file
cat <<EOF > /etc/boto.cfg
[Credentials]
gs_service_client_id = $gs_service_client_id
gs_service_key_file = $RESTORE_DIR/service-account.json
[Boto]
https_validate_certificates = True
[GSUtil]
content_language = en
default_api_version = 2
default_project_id = $gs_project_id
EOF

DB_HOST="$MONGO_HOST"
BUCKET_NAME="$GS_RESTORE_BUCKET"
FILE="$GS_RESTORE_FILE"

if [ -z "$DB_HOST" ]; then
    echo "DB_HOST is empty."
    exit 1
fi
if [ -z "$BUCKET_NAME" ]; then
    echo "BUCKET_NAME is empty."
    exit 1
fi
if [ -z "$FILE" ]; then
    echo "FILE is empty."
    exit 1
fi

mkdir -p $RESTORE_DIR
cd $RESTORE_DIR

GZIP=""
if [[ $FILE =~ \.gz$ ]]; then
    GZIP="--gzip"
fi

# pull from GCE
echo "Copying gs://$BUCKET_NAME/$FILE to $RESTORE_DIR/$FILE"
/root/gsutil/gsutil cp gs://$BUCKET_NAME/$FILE $FILE 2>&1

mongorestore --host "$DB_HOST" $GZIP --archive="$FILE"
