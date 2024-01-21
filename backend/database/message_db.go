package database

import (
	"fmt"
	"log"

	_ "github.com/lib/pq"
	"github.com/oAndBtech/private_chat/backend/model"
)

func AddMessage(userId int, roomId string, msg []byte, isText bool, senderName string, uniqueId string, replyTo any) bool {
	query := "INSERT INTO messages (content, sender, receiver, istext, sendername, uniqueid, replyto) VALUES ($1, $2, $3, $4, $5, $6, $7)"
	_, err := db.Exec(query, msg, userId, roomId, isText, senderName, uniqueId, replyTo)
	if err != nil {
		log.Println(err)
		return false
	}
	return true
}

func AllMessagesInRoom(roomId string) ([]model.MessageModel, error) {
	query := "SELECT * FROM messages WHERE receiver = $1 ORDER BY timestamp ASC"
	rows, err := db.Query(query, roomId)
	if err != nil {
		return nil, fmt.Errorf("error getting all messages: %v", err)
	}
	defer rows.Close()
	var messages []model.MessageModel

	for rows.Next() {
		var message model.MessageModel
		err := rows.Scan(&message.ID, &message.Content, &message.Sender, &message.Receiver, &message.IsText, &message.Timestamp, &message.SenderName, &message.UniqueId, &message.ReplyTo)
		if err != nil {
			return nil, fmt.Errorf("error scanning message row: %v", err)
		}
		messages = append(messages, message)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("error iterating over messages rows: %v", err)
	}
	return messages, nil
}
