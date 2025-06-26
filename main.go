package main

import (
	"log"
	"os"
	"os/exec"

	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase"
	_ "github.com/lib/pq" // Sadece PostgreSQL driver
)

func main() {
	app := pocketbase.NewWithConfig(pocketbase.Config{
		DBConnect: func(dbPath string) (*dbx.DB, error) {
			// Railway PostgreSQL bağlantısı
			databaseURL := os.Getenv("DATABASE_URL")
			if databaseURL == "" {
				log.Fatal("DATABASE_URL environment variable is required for PostgreSQL")
			}
			return dbx.Open("postgres", databaseURL)
		},
	})

	// Superuser otomatik oluştur
	cmd := exec.Command(os.Args[0], "superuser", "upsert", "kenbladex1@gmail.com", "Mc255241@+")
	if err := cmd.Run(); err != nil {
		log.Println("Superuser oluşturulamadı:", err)
	}

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}
