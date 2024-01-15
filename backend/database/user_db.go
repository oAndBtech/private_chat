package database

import (
	"fmt"
	"log"
	"strings"

	"github.com/oAndBtech/private_chat/backend/model"
)

func User(id int) (model.UserModel, error) {
	query := "SELECT * FROM users WHERE id = $1"
	var user model.UserModel
	err := db.QueryRow(query, id).Scan(&user.ID, &user.Name, &user.Phone, &user.FcmToken, &user.WebFcmToken, &user.Notif)
	if err != nil {
		return model.UserModel{}, fmt.Errorf("error retrieving user: %v", err)
	}
	return user, nil
}

func AddUser(user model.UserModel) (model.UserModel, error) {
	query := "INSERT INTO users (name, phone, fcmtoken, webfcmtoken) VALUES ($1, $2, $3, $4) RETURNING *"

	var newUser model.UserModel
	err := db.QueryRow(query, user.Name, user.Phone, user.FcmToken, user.WebFcmToken).Scan(
		&newUser.ID,
		&newUser.Name,
		&newUser.Phone,
		&newUser.FcmToken,
		&newUser.WebFcmToken,
		&newUser.Notif,
	)
	if err != nil {
		log.Println("Error adding user:", err)
		return model.UserModel{}, fmt.Errorf("ERROR: %s", err)
	}

	return newUser, nil
}

func UpdateUser(id int, user model.UserModel) bool {
	fields := map[string]interface{}{
		"name":        user.Name,
		"phone":       user.Phone,
		"fcmtoken":    user.FcmToken,
		"webfcmtoken": user.WebFcmToken,
	}

	var setStatements []string
	var values []interface{}
	var index = 1

	for k, v := range fields {
		if v != nil && v != "" {
			setStatements = append(setStatements, fmt.Sprintf("%s = $%d", k, index))
			values = append(values, v)
			index++
		}
	}

	if index == 1 {
		log.Println("No given data for updating user")
		return false
	}

	query := fmt.Sprintf("UPDATE users SET %s WHERE id = $%d", strings.Join(setStatements, ", "), index)
	values = append(values, id)

	res, err := db.Exec(query, values...)
	if err != nil {
		log.Printf("Error while updating user id=%d, err: %v\n", id, err)
		return false
	}

	affectedRows, err := res.RowsAffected()
	if err != nil {
		log.Printf("Error getting affected rows: %v\n", err)
		return false
	}

	if affectedRows == 0 {
		log.Printf("No rows updated for ID: %d\n", id)
	} else {
		log.Printf("Updated %d rows for ID: %d\n", affectedRows, id)
	}
	return true
}

func UpdateNotificationStatus(id int, value bool) bool {
	query := "UPDATE users SET notif = $1 WHERE id = $2"
	res, err := db.Exec(query, value, id)
	if err != nil {
		log.Printf("Error while updating notifcation status, user id=%d, err: %v\n", id, err)
		return false
	}
	affectedRows, err := res.RowsAffected()
	if err != nil {
		log.Printf("Error getting affected rows: %v\n", err)
		return false
	}

	if affectedRows == 0 {
		log.Printf("No rows updated for ID: %d\n", id)
	} else {
		log.Printf("Updated %d rows for ID: %d\n", affectedRows, id)
	}
	return true
}

func DeleteUser(id int) bool {
	query := "DELETE FROM users WHERE id = $1"

	result, err := db.Exec(query, id)

	if err != nil {
		log.Printf("Error while deleting user id= %d, err: %v", id, err)
		return false
	}

	deletedRow, err := result.RowsAffected()
	if err != nil {
		log.Println(err)
		return false
	}

	log.Printf("Deleted %d rows fromusers", deletedRow)
	return true
}

func UsersName(userId int) (string, error) {
	query := "SELECT name FROM users WHERE id = $1"
	var userName string
	err := db.QueryRow(query, userId).Scan(&userName)
	if err != nil {
		return userName, fmt.Errorf("error while fetching users name: %s", err)
	}
	return userName, nil
}

func VerifyUser(userId int) bool {
	query := "SELECT EXISTS(SELECT 1 FROM users WHERE id = $1)"
	var exists bool

	err := db.QueryRow(query, userId).Scan(&exists)
	if err != nil {
		log.Printf("error verifying user id = %v, error: %v", userId, err)
		return false
	}
	return exists
}

func CheckUserExistsDB(phone string) (bool, model.UserModel) {
	query := "SELECT EXISTS(SELECT 1 FROM users WHERE phone = $1)"
	var exists bool
	var user model.UserModel

	err := db.QueryRow(query, phone).Scan(&exists)
	if err != nil {
		log.Printf("error checking users phone = %v, error: %v", phone, err)
		return false, user
	}
	if exists {
		query = "SELECT * FROM users WHERE phone = $1"
		err := db.QueryRow(query, phone).Scan(&user.ID, &user.Name, &user.Phone, &user.FcmToken, &user.WebFcmToken, &user.Notif)
		if err != nil {
			log.Printf("error checking users phone: %v", err)
			return false, user
		}
		return true, user
	}
	return false, user
}

func GetAllFCMTokensInARoom(roomId string, senderId int) ([]string, error) {
	users, err := UsersInRoom(roomId)
	if err != nil {
		return []string{}, err
	}

	var tokens []string
	for _, user := range users {
		if senderId != user.ID && user.FcmToken != nil && user.FcmToken != "" && user.Notif {
			tokens = append(tokens, user.FcmToken.(string))
		}
		if senderId != user.ID && user.WebFcmToken != nil && user.WebFcmToken != "" && user.Notif {
			tokens = append(tokens, user.WebFcmToken.(string))
		}
	}
	return tokens, nil
}
