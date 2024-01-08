package database

import (
	"fmt"

	_ "github.com/lib/pq"
	"github.com/oAndBtech/private_chat/backend/model"
)

func AddMessage(userId int, roomId string, msg []byte) bool {
	query := "INSERT INTO messages (content, sender, receiver, istext) VALUES ($1, $2, $3, $4)"
	_, err := db.Exec(query, msg, userId, roomId, true) //TODO: take isText variable from frontend and then change it
	if err != nil {
		fmt.Println(err)
		return false
	}
	return true
}

func AllMessagesInRoom(roomId string) ([]model.MessageModel, error) {
	query := "SELECT * FROM messages WHERE receiver = $1"
	rows, err := db.Query(query, roomId)
	if err != nil {
		return nil, fmt.Errorf("error getting all messages: %v", err)
	}
	defer rows.Close()
	var messages []model.MessageModel

	for rows.Next() {
		var message model.MessageModel
		err := rows.Scan(&message.ID, &message.Content, &message.Sender, &message.Receiver, &message.IsText, &message.Timestamp)
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
