package database

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
)

var db *sql.DB

func InitDB(datab *sql.DB) {
	db = datab
	log.Println("DB initialized")
}
