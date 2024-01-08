package database

import (
	"fmt"
	"log"
)

func AddRoom(roomId string) bool {
	query := "INSERT INTO rooms (roomid) VALUES $1"

	_, err := db.Exec(query, roomId)
	if err != nil {
		log.Fatalf("Error while adding room,%v", err)
		return false
	}
	return true
}

func UpdateRoomID(oldRoomID, newRoomID string) {
	//TODO: do it later no need as of now
}

func DeleteRoom(roomId string) error {
	roomUserQuery := "DELETE FROM room_user WHERE roomid = $1"
	_, err := db.Exec(roomUserQuery, roomId)
	if err != nil {
		return fmt.Errorf("error deleting room_user rows: %v", err)
	}

	messageQuery := "DELETE FROM messages WHERE receiver = $1"
	_, err = db.Exec(messageQuery, roomId)
	if err != nil {
		return fmt.Errorf("error deleting messages rows: %v", err)
	}

	roomQuery := "DELETE FROM rooms WHERE roomid = $1"
	_, err = db.Exec(roomQuery, roomId)
	if err != nil {
		return fmt.Errorf("error deleting rooms rows: %v", err)
	}

	return nil
}
