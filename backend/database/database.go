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



