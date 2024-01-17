package controller

import (
	"encoding/json"
	"log"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
	"github.com/oAndBtech/private_chat/backend/database"
	"github.com/oAndBtech/private_chat/backend/model"
)

func GetRoom(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
	w.Header().Set("Content-Type", "application/json")

	params := mux.Vars(r)
	roomId, ok := params["id"]
	if !ok {
		log.Println("Not a valid ID while fetching room")
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "Please provide a valid ID"})
		return
	}

	room, err := database.Room(roomId)
	if err != nil {
		log.Println(err)
		w.WriteHeader(http.StatusNotFound)
		json.NewEncoder(w).Encode(map[string]string{"error": "Room not found"})
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(room)
}

func AddRoom(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
	w.Header().Set("Content-Type", "application/json")

	var room model.RoomModel
	err := json.NewDecoder(r.Body).Decode(&room)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "Invalid JSON format"})
		return
	}

	result := database.AddRoom(room.RoomId)
	if !result {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "Error adding new room"})
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]string{"message": "Successfully added new room"})
}

func DeleteRoom(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "DELETE")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
	w.Header().Set("Content-Type", "application/json")

	params := mux.Vars(r)
	roomId, ok := params["id"]

	if !ok {
		log.Println("Invalid Room ID")
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "Invalid Room ID"})
		return
	}

	err := database.DeleteRoom(roomId)

	if err != nil {
		log.Printf("Failed to delete room ID=%v, Error: %v", roomId, err)
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to delete room"})
		return
	}

	w.WriteHeader(http.StatusNoContent)
	json.NewEncoder(w).Encode(map[string]string{"message": "Successfully deleted"})
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
		log.Println("Please provide a valid ID")
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "Please provide a valid ID"})
		return
	}

	messages, err := database.AllMessagesInRoom(roomId)

	if err != nil {
		log.Printf("Error while getting all messages in controller: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to get all messages in room"})
		return
	}

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
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
	w.Header().Set("Content-Type", "application/json")

	params := mux.Vars(r)
	roomId, ok := params["id"]
	if !ok {
		log.Println("Please provide a valid ID")
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "Please provide a valid ID"})
		return
	}

	users, err := database.UsersInRoom(roomId)
	if err != nil {
		log.Printf("Error while fetching all users in a room: %v", err.Error())
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to get all users"})
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

func UpdateRoom(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
	w.Header().Set("Content-Type", "application/json")

	params := mux.Vars(r)
	idStr, ok := params["id"]
	if !ok {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "Invalid ID"})
		return
	}

	var room model.RoomModel
	err := json.NewDecoder(r.Body).Decode(&room)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "Invalid JSON format"})
		return
	}

	isRoomExists, err := database.VerifyRoomId(idStr)
	if err != nil || !isRoomExists {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "Room does not exist"})
		return
	}

	str, ok := room.RoomName.(string)
	if !ok {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "Invalid room name format"})
		return
	}

	result := database.UpdateRoomName(str, idStr)
	if !result {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "Failed to update room name"})
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message":  "Successfully updated",
		"roomid":   idStr,
		"roomname": str,
	})
}

func ExitRoom(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
	w.Header().Set("Content-Type", "application/json")

	// Retrieve query parameters
	userID := r.FormValue("userId")
	roomID := r.FormValue("roomId")

	userIdInteger, err := strconv.Atoi(userID)
	if err != nil {
		log.Println(err)
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{
			"message": "Failed to exit",
			"error":   err.Error(),
		})
		return
	}

	// Check if the user exists in the database
	userExists := database.VerifyUser(userIdInteger)
	if !userExists {
		log.Println("Wrong user ID")
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{
			"message": "Failed to exit",
			"error":   "Wrong user ID",
		})
		return
	}

	// Check if the room ID exists
	roomExists, err := database.VerifyRoomId(roomID)
	if err != nil {
		log.Println(err)
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{
			"message": "Failed to exit",
			"error":   err.Error(),
		})
		return
	}

	if !roomExists {
		log.Println("Wrong room ID")
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{
			"message": "Failed to exit",
			"error":   "Wrong room ID",
		})
		return
	}

	result := database.ExitRoom(userIdInteger, roomID)

	if !result {
		log.Println("Failed to exit room")
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{
			"message": "Failed to exit",
		})
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{
		"message": "Successfully exited room",
	})
}
