package notifications

import (
	"context"
	"fmt"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/messaging"
)

var app *firebase.App

func InitFirebase(firebaseApp *firebase.App) {
	app = firebaseApp
	fmt.Println("Firebase Admin SDK Initialized")
}

func SendPushNotification(fcmTokens []string) {
	ctx := context.Background()

	client, err := app.Messaging(ctx)
	if err != nil {
		fmt.Printf("error getting Messaging client: %v\n", err)
		return
	}

	//TODO: CHNAGE THIS
	message := &messaging.MulticastMessage{
		Notification: &messaging.Notification{
			Title: "Hello",
			Body:  "World",
		},
		Tokens: fcmTokens,
	}

	response, err := client.SendMulticast(ctx, message)
	if err != nil {
		fmt.Printf("error sending multicast message: %v\n", err)

	}

	for _, resp := range response.Responses {
		fmt.Printf("Successfully sent message to %v: %v\n", resp.MessageID, resp.Success)
	}

	if response.FailureCount > 0 {
		fmt.Printf("%d messages failed to send\n", response.FailureCount)
	} else {
		fmt.Println("All messages sent successfully!")
	}
}
