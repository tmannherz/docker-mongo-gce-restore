# MongoDB restore from Google Cloud Storage

A docker image to restore a MongoDB database archive from Google Cloud Storage.

The container runs `mongorestore` to restore a gzipped archive (`--gzip --archive`) pulled from GS to a running Docker container hosting the MongoDB server. The archive has the database name embedded.

This image is a compliment to https://github.com/tmannherz/docker-mongo-gce-backup.

## Environment Variables

* `MONGO_HOST` - Host of running MongoDB instance
* `GS_PROJECT_ID` - GCE project ID
* `GS_SERVICE_EMAIL` - Email of service account to use
* `GS_RESTORE_BUCKET` - Cloud storage bucket pull from
* `GS_RESTORE_FILE` - Archive file name to restore

The restore script expects a service account auth JSON file in `/restore/service-account.json`.

## Run

```
docker run --name restore \
  -v service-account.json:/restore/service-account.json:ro \
  -e MONGO_HOST=db \
  -e GS_PROJECT_ID=my-project \
  -e GS_SERVICE_EMAIL=email@proj.iam.gserviceaccount.com \
  -e GS_RESTORE_BUCKET=my-bucket \
  -e GS_RESTORE_FILE=backup.archive.gz \
  --network default \
  --link service_db:db \
  tmannherz/mongo-gce-restore
```