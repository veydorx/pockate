package main

import (
    "log"
    "github.com/pocketbase/dbx"
    "github.com/pocketbase/pocketbase"
    _ "github.com/mattn/go-sqlite3"
)

func main() {
    app := pocketbase.NewWithConfig(pocketbase.Config{
        DBConnect: func(dbPath string) (*dbx.DB, error) {
            // SQLite PRAGMA optimizasyonları
            pragmas := "?_pragma=busy_timeout(10000)" +
                "&_pragma=journal_mode(WAL)" +
                "&_pragma=journal_size_limit(200000000)" +
                "&_pragma=synchronous(NORMAL)" +
                "&_pragma=foreign_keys(ON)" +
                "&_pragma=temp_store(MEMORY)" +
                "&_pragma=cache_size(-16000)"
            return dbx.Open("sqlite3", "file:"+dbPath+pragmas)
        },
    })

    if err := app.Start(); err != nil {
        log.Fatal(err)
    }
}