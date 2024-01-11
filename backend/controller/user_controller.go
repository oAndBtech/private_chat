package controller

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
	"github.com/oAndBtech/private_chat/backend/database"
	"github.com/oAndBtech/private_chat/backend/model"
)

func GetUser(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)
	userId, ok := params["id"]
	if !ok {
		fmt.Println("Please provide a valid id")
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Please provide a valid id")
		return
	}

	integerId, err := strconv.Atoi(userId)

	if err != nil {
		fmt.Println(err)
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(err)
		return
	}

	user, err := database.User(integerId)

	if err != nil {
		fmt.Println(err)
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("failed to get details of user")
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(user)
}

func AddUser(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	var user model.UserModel
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Invalid JSON format")
		return
	}

	//TODO: check usr is already there in db

	userAlreadyInDb, existedUser := database.CheckUserExistsDB(user.Phone)

	if userAlreadyInDb {
		fmt.Println("USERS PHONE NUMBER IS ALREADY IN DB")
		w.WriteHeader(http.StatusResetContent) // it will return 205
		json.NewEncoder(w).Encode(existedUser)
		return
	}

	addedUser, err := database.AddUser(user)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("failed to add user")
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(addedUser)
}

func UpdateUser(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)
	idStr, ok := params["id"]
	if !ok {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Please provide a valid ID")
		return
	}
	id, err := strconv.Atoi(idStr)

	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Invalid ID")
		return
	}

	var user model.UserModel
	err2 := json.NewDecoder(r.Body).Decode(&user)
	if err2 != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Invalid JSON format")
		return
	}

	result := database.UpdateUser(id, user)
	if !result {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Failed to update")
		return
	}
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode("Successfully updated")
}

func DeleteUser(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	params := mux.Vars(r)
	idStr, ok := params["id"]
	if !ok {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Please provide a valid ID")
		return
	}

	id, err := strconv.Atoi(idStr)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Invalid ID")
		return
	}

	result := database.DeleteUser(id)
	if !result {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("failed to delete user")
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode("Successfully user deleted")
}
