package database

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq"
)

var db *sql.DB

func InitDB(datab *sql.DB) {
	db = datab
	fmt.Println("DB initialized")
}





