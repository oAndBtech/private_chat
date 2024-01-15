package notifications

import (
	"fmt"
	"log"

	"github.com/oAndBtech/private_chat/backend/database"
)

func NewMessageArriveNotification(roomId string, senderName string, senderId int, isText bool) {
	var body string
	var title string

	room, err := database.Room(roomId)

	if err != nil {
		log.Printf("Error while fetching room for sending notification: %s\n", err)
		return
	}

	if isText {
		body = fmt.Sprintf("%s sent a message", senderName)
	} else {
		body = fmt.Sprintf("%s sent a image", senderName)
	}

	if room.RoomName == nil || room.RoomName == "" {
		title = "New Message!"
	} else {
		title = room.RoomName.(string)
	}

	fcmTokens, err := database.GetAllFCMTokensInARoom(roomId, senderId)

	if err != nil {
		log.Printf("ERROR while sending notification: %s", err)
		return
	}

	if fcmTokens == nil {
		log.Println("No fcm tokens present")
		return
	}
	SendPushNotification(fcmTokens, title, body)
}
