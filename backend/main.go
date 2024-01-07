package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/oAndBtech/private_chat/backend/database"
	"github.com/oAndBtech/private_chat/backend/env"
	"github.com/oAndBtech/private_chat/backend/router"
)

var db *sql.DB

func main() {
	env.LoadEnv()

	connStr := os.Getenv("DB_CONNSTRING")
	var err error
	db, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}

	if err = db.Ping(); err != nil {
		log.Fatal(err)
	}

	database.InitDB(db)

	r := router.Router()
	err = http.ListenAndServe(":3000", r)
	if err != nil {
		fmt.Println(err)
	}
	// res, err := database.CheckUserIsInRoom(1, "45")
	// if err != nil {
	// 	fmt.Println(err)
	// } else {
	// 	fmt.Println(res)
	// }

}
