package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
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

	//Initialize Firebase Admin SDK
	opt := option.WithCredentialsFile("credentials.json")
	app, err = firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		log.Fatal(err)
	}
	notifications.InitFirebase(app)

	tokens := []string{"euX-WEFPQnCszn8SuutA7Q:APA91bFQTNx7s1GBFBwaZofloDfhUW6j9ZPZSFRjE0xqJDHFl2CK11QmfVGyeUZ1vELNY--ggtJ9kCfbL9r2RR7rhgyOiLkIfZtRWFop7pkUNA6dmnO4F5NSKmCWiBAAIHVmIZHbkXiM"}

	notifications.SendPushNotification(tokens, "Hello Omkar", "Tu madarchod hai")

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
