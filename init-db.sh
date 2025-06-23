#!/bin/sh

echo "Starting fresh DB..."

echo "Applying PRAGMA & WAL settings..."
sqlite3 ./pb_data/data.db "PRAGMA journal_mode=WAL;"
sqlite3 ./pb_data/data.db "PRAGMA synchronous=NORMAL;"
sqlite3 ./pb_data/data.db "PRAGMA temp_store=MEMORY;"
sqlite3 ./pb_data/data.db "PRAGMA cache_size=10000;"

echo "Database tuned."

exec ./pocketbase serve --dir pb_data --http 0.0.0.0:3000