package main

import (
	"log"
	"os"

	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/plugins/migratecmd"
)

func main() {
	app := pocketbase.New()

	// DATABASE_URL from env
	dbUrl := os.Getenv("DATABASE_URL")
	if dbUrl == "" {
		log.Fatal("DATABASE_URL environment variable is not set")
	}

	// PostgreSQL bağlantısını veritabanı başlangıcında kur
	app.OnBeforeBootstrap().Add(func(e *pocketbase.BootstrapEvent) error {
		e.App.DataDir = "" // SQLite kullanılmasın
		e.App.Settings().Db = dbUrl
		return nil
	})

	// Migration komutlarını ekle
	migratecmd.MustRegister(app, app.RootCmd)

	// Uygulama başlat
	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}
