package controller

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/oAndBtech/private_chat/backend/database"
	"github.com/oAndBtech/private_chat/backend/model"
)

// func GetRoom(w http.ResponseWriter, r *http.Request) {
// 	w.Header().Set("Content-Type", "application/json")
// 	params := mux.Vars(r)
// 	roomId,ok := params["id"]
// 	if !ok {
// 		fmt.Println("not a valid id while fetching room")
// 		w.WriteHeader(http.StatusBadRequest)
// 		json.NewEncoder(w).Encode("Please provide a valid id")
// 		return
// 	}

// }

func AddRoom(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	var room model.RoomModel
	err := json.NewDecoder(r.Body).Decode(&room)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Invalid JSON format")
		return
	}

	result := database.AddRoom(room.RoomId)
	if !result {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("error adding new room")
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode("Successfully room added")
}

func DeleteRoom(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	params := mux.Vars(r)
	roomId, ok := params["id"]

	if !ok {
		fmt.Println("Inavild Room ID")
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Invalid Room ID")
		return
	}

	err := database.DeleteRoom(roomId)

	if err != nil {
		fmt.Printf("failed to delete room id= %v", roomId)
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("failed to delete room")
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode("Successfully deleted")
}

func MessagesInRoom(w http.ResponseWriter, r *http.Request) {
	// Set CORS headers
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	w.Header().Set("Content-Type", "application/json")

	params := mux.Vars(r)
	roomId, ok := params["id"]

	if !ok {
		fmt.Println("Please provide a valid id")
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Please provide a valid id")
		return
	}

	messages, err := database.AllMessagesInRoom(roomId)

	if err != nil {
		fmt.Printf("error while getting all messgaes in controller,%v", err)
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Failed to get all messages in room")
		return
	}

	fmt.Println(messages)

	if messages == nil {
		w.WriteHeader(http.StatusOK)
		emptyList := []string{}
		json.NewEncoder(w).Encode(emptyList)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(messages)
}

func AllUserInRoom(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	params := mux.Vars(r)
	roomId, ok := params["id"]
	if !ok {
		fmt.Println("Please provide a valid id")
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Please provide a valid id")
		return
	}

	users, err := database.UsersInRoom(roomId)
	if err != nil {
		fmt.Println("Error while fetching all users in a room")
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("failed to get all users")
		return
	}

	if users == nil {
		w.WriteHeader(http.StatusOK)
		emptyList := []string{}
		json.NewEncoder(w).Encode(emptyList)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(users)
}
