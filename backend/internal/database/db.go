package database

import (
    "log"
    "os"
    "github.com/Oik17/yantra-hack/internal/utils"
    "github.com/jmoiron/sqlx"
    _ "github.com/lib/pq"
)


type Dbinstance struct {
	Db *sqlx.DB
}

var DB Dbinstance

func Connect() {
    dsn := utils.Config("DATABASE_URL")
    
    if dsn == "" {
        log.Fatal("DATABASE_URL environment variable not set")
        os.Exit(2)
    }
    
    db, err := sqlx.Open("postgres", dsn)
    if err != nil {
        log.Fatal(err.Error())
        log.Fatal("Failed to connect to database. \n", err)
        os.Exit(2)
    }

    if err := db.Ping(); err != nil {
        log.Fatal(err.Error())
        log.Fatal("Failed to ping the database. \n", err)
        os.Exit(2)
    }

    log.Println("Connected")

    runMigrations(db)

    DB = Dbinstance{
        Db: db,
    }
}

func runMigrations(db *sqlx.DB) {
	_, err := db.Exec(`
		CREATE TABLE IF NOT EXISTS test (test VARCHAR(255));
		CREATE TABLE IF NOT EXISTS solar_inputs (
			id UUID PRIMARY KEY,
			panel_area INTEGER,
			efficiency_rating INTEGER,
			panel_age INTEGER 
		);
	`)

	if err != nil {
		log.Fatal("Failed to run migrations. \n", err)
		os.Exit(2)
	}

	log.Println("Migrations completed")
}
