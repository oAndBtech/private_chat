package database

import (
	"database/sql"
	"fmt"
	"log"

	"github.com/oAndBtech/private_chat/backend/model"
)

func Room(roomId string) (model.RoomModel, error) {
	query := "SELECT * FROM rooms WHERE roomid = $1"
	var room model.RoomModel
	err := db.QueryRow(query, roomId).Scan(&room.ID, &room.RoomId, &room.RoomName)
	if err != nil {
		if err == sql.ErrNoRows {
			return model.RoomModel{}, fmt.Errorf("no room found with ID %s", roomId)
		}
		return model.RoomModel{}, fmt.Errorf("error retrieving room: %v", err)
	}
	return room, nil
}

func AddRoom(roomId string) bool {
	query := "INSERT INTO rooms (roomid) VALUES ($1)"

	_, err := db.Exec(query, roomId)
	if err != nil {
		log.Printf("Error while adding room,%v", err)
		return false
	}
	return true
}

func UpdateRoomName(newRoomName, roomId string) bool {
	query := "UPDATE rooms SET roomname = $1 WHERE roomid = $2"

	_, err := db.Exec(query, newRoomName, roomId)
	if err != nil {
		log.Printf("Error while updating room,%v", err)
		return false
	}
	return true
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

func VerifyRoomId(roomId string) (bool, error) {
	query := "SELECT EXISTS(SELECT 1 FROM rooms WHERE roomid = $1)"
	var exists bool
	err := db.QueryRow(query, roomId).Scan(&exists)
	if err != nil {
		return false, fmt.Errorf("error verifying room ID: %v", err)
	}
	return exists, nil
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
		log.Printf("User %d added to room %s\n", userId, roomId)
	}

	return nil
}

func UsersInRoom(roomId string) ([]model.UserModel, error) {
	// query := "SELECT * FROM users WHERE roomId"
	query := "SELECT userid FROM room_user WHERE roomid = $1"

	rows, err := db.Query(query, roomId)

	if err != nil {
		return nil, fmt.Errorf("error getting all users in room: %v", err)
	}
	defer rows.Close()
	var users []model.UserModel

	for rows.Next() {
		var userId int
		err := rows.Scan(&userId)

		if err != nil {
			return nil, fmt.Errorf("error scanning room_user row: %v", err)
		}

		query := "SELECT * FROM users WHERE id = $1"

		var user model.UserModel
		db.QueryRow(query, userId).Scan(&user.ID, &user.Name, &user.Phone, &user.FcmToken, &user.WebFcmToken, &user.Notif)
		users = append(users, user)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("error iterating over room_user rows: %v", err)
	}
	return users, nil
}
