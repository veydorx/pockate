package main

import (
	"log"
	"os"

	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/core"
	_ "github.com/lib/pq"
)

func main() {
	app := pocketbase.New()

	// PostgreSQL bağlantısı için hook
	app.OnBeforeServe().Add(func(e *core.ServeEvent) error {
		// DATABASE_URL kontrolü
		databaseURL := os.Getenv("DATABASE_URL")
		if databaseURL == "" {
			log.Fatal("DATABASE_URL environment variable is required")
		}
		
		log.Printf("Using PostgreSQL database: %s", databaseURL)
		return nil
	})

	// Superuser oluşturma hook'u
	app.OnAfterBootstrap().Add(func(e *core.BootstrapEvent) error {
		// Admin kullanıcısı oluştur
		admin := &core.Admin{}
		admin.Email = "kenbladex1@gmail.com"
		admin.SetPassword("Mc255241@+")
		
		// Mevcut admin var mı kontrol et
		_, err := app.Dao().FindAdminByEmail(admin.Email)
		if err != nil {
			// Admin yoksa oluştur
			if err := app.Dao().SaveAdmin(admin); err != nil {
				log.Printf("Admin oluşturulamadı: %v", err)
			} else {
				log.Printf("Admin kullanıcısı oluşturuldu: %s", admin.Email)
			}
		}
		
		return nil
	})

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}
