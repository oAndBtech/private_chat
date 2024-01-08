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

func CheckUserIsInRoom(userId int, roomId string) (bool, error) {
	query := "SELECT EXISTS(SELECT 1 FROM room_user WHERE userid = $1 AND roomid = $2)"
	var exists bool
	err := db.QueryRow(query, userId, roomId).Scan(&exists)
	if err != nil {
		return false, fmt.Errorf("error checking user in room: %v", err)
	}
	return exists, nil
}

func AddUserInRoom(userId int, roomId string) error {
	exists, err := CheckUserIsInRoom(userId, roomId)
	if err != nil {
		return err
	}

	if !exists { //if not in room
		query := "INSERT INTO room_user (userid, roomid) VALUES ($1, $2)"
		_, err := db.Exec(query, userId, roomId)
		if err != nil {
			return fmt.Errorf("error adding user to room: %v", err)
		}
		fmt.Printf("User %d added to room %s\n", userId, roomId)
	}

	return nil
}

func VerifyRoomId(roomId string) (bool, error) {
	query := "SELECT EXISTS(SELECT 1 FROM rooms WHERE roomid = $1)"
	var exists bool
	err := db.QueryRow(query, roomId).Scan(&exists)
	if err != nil {
		return false, fmt.Errorf("error verifying room ID: %v", err)
	}
	return exists, nil
}

func VerifyUser(userId int) bool {
	query := "SELECT EXISTS(SELECT 1 FROM users WHERE id = $1)"
	var exists bool

	err := db.QueryRow(query, userId).Scan(&exists)
	if err != nil {
		fmt.Printf("error verifying user id = %v, error: %v", userId, err)
		return false
	}
	return exists
}
