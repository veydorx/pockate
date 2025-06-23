#!/bin/bash

DB_PATH="./pb_data/data.db"
PORT=${PORT:-3000}

if [ ! -f "$DB_PATH" ]; then
    echo "Starting fresh DB..."
    ./pocketbase serve --http=:"$PORT" &

    sleep 3

    echo "Applying PRAGMA & WAL settings..."
    sqlite3 "$DB_PATH" "PRAGMA journal_mode=WAL;"
    sqlite3 "$DB_PATH" "PRAGMA synchronous=NORMAL;"
    sqlite3 "$DB_PATH" "PRAGMA cache_size=10000;"
    sqlite3 "$DB_PATH" "PRAGMA temp_store=MEMORY;"

    pkill pocketbase
    sleep 1
fi

exec ./pocketbase serve --http=:"$PORT"
