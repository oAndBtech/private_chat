package main

import (
	"context"
	"database/sql"
	"log"
	"log/slog"
	"net/http"
	"os"

	firebase "firebase.google.com/go"
	"github.com/oAndBtech/private_chat/backend/database"
	"github.com/oAndBtech/private_chat/backend/env"
	"github.com/oAndBtech/private_chat/backend/notifications"
	"github.com/oAndBtech/private_chat/backend/router"
	"google.golang.org/api/option"
)

var db *sql.DB
var app *firebase.App

func main() {
	env.LoadEnv()

	logger := slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{
		Level: slog.LevelDebug,
	}))
	slog.SetDefault(logger)

	connStr := os.Getenv("DB_CONNSTRING")
	var err error
	db, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Println(err.Error())
	}

	if err = db.Ping(); err != nil {
		log.Println(err.Error())
	}

	database.InitDB(db)

	//Initialize Firebase Admin SDK
	opt := option.WithCredentialsFile("credentials.json")
	app, err = firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		log.Println(err.Error())
	}
	notifications.InitFirebase(app)
	
	r := router.Router()
	err = http.ListenAndServe(":3000", r)
	if err != nil {
		log.Println(err.Error())
	}

}
