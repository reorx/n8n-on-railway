#!/usr/bin/env bash

: ${EXPORT_DIR:="n8n-$(date +%Y%m%d)"}
: ${DEST_DIR:=workflows}

: ${EXPORT_HOST:="reorx@harrogath"}
: ${EXPORT_ROOT:="/share/CACHEDEV1_DATA/homes/reorx/Misc_Backup/"}

download_dir=exports

set -eux

railway run \
    docker run \
        -e N8N_ENCRYPTION_KEY \
        -e GENERIC_TIMEZONE \
        -e TZ \
        -e DB_TYPE \
        -e DB_POSTGRESDB_DATABASE \
        -e DB_POSTGRESDB_HOST \
        -e DB_POSTGRESDB_PORT \
        -e DB_POSTGRESDB_USER \
        -e DB_POSTGRESDB_SCHEMA \
        -e DB_POSTGRESDB_PASSWORD \
        -v $EXPORT_ROOT:/backup \
        -u node \
        reorx/n8n-custom n8n export:workflow --backup --output=/backup/$EXPORT_DIR/

rsync -ar ${EXPORT_HOST}:${EXPORT_ROOT}${EXPORT_DIR} $download_dir
