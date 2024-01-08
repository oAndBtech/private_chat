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
	err := db.QueryRow(query, id).Scan(&user.ID, &user.Name, &user.Phone, &user.FcmToken)
	if err != nil {
		return model.UserModel{}, fmt.Errorf("error retrieving user: %v", err)
	}
	return user, nil
}

func AddUser(user model.UserModel) bool {
	query := "INSERT INTO users (name, phone, fcmtoken) VALUES ($1, $2, $3)"

	_, err := db.Exec(query, user.Name, user.Phone, user.FcmToken)
	if err != nil {
		fmt.Println("Error adding user:", err)
		return false
	}
	return true
}

func UpdateUser(id int, user model.UserModel) bool {
	fields := map[string]interface{}{
		"name":     user.Name,
		"phone":    user.Phone,
		"fcmtoken": user.FcmToken,
	}

	var setStatements []string
	var values []interface{}
	var index = 1

	for k, v := range fields {
		if v != nil && v != "" {
			setStatements = append(setStatements, fmt.Sprintf("%s = %d", k, index))
			values = append(values, v)
			index++
		}
	}

	if index == 1 {
		fmt.Println("No given data for updating user")
		return false
	}

	query := fmt.Sprintf(`UPDATE users SET %s WHERE id $%d`, strings.Join(setStatements, ", "), index)

	values = append(values, id)

	res, err := db.Exec(query, values...)
	if err != nil {
		log.Fatalf("Error while updating user id=%d, err: %v", id, err)
		return false
	}

	affectedRows, err := res.RowsAffected()

	if err != nil {
		log.Fatal(err)
		return false
	}

	if affectedRows == 0 {
		fmt.Printf("No rows updated for ID: %d\n", id)
	} else {
		fmt.Printf("Updated %d rows for ID: %d\n", affectedRows, id)
	}
	return true
}

func DeleteUser(id int) bool {
	query := "DELETE FROM users WHERE id = $1"

	result, err := db.Exec(query, id)

	if err != nil {
		log.Fatalf("Error while deleting user id= %d, err: %v", id, err)
		return false
	}

	deletedRow, err := result.RowsAffected()
	if err != nil {
		log.Fatal(err)
		return false
	}

	log.Printf("Deleted %d rows fromusers", deletedRow)
	return true
}
