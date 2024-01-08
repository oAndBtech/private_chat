package controller

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/oAndBtech/private_chat/backend/database"
	"github.com/oAndBtech/private_chat/backend/model"
)

func AddRoom(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	var room model.RoomModel
	err := json.NewDecoder(r.Body).Decode(&room)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Invalid JSON format")
	}

	result := database.AddRoom(room.RoomId)
	if !result {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("error adding new room")
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode("Successfully room added")
}

func DeleteRoom(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	params := mux.Vars(r)
	roomId, ok := params["id"]

	if !ok {
		log.Fatal("Inavild Room ID")
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Invalid Room ID")
	}

	result := database.AddRoom(roomId)

	if !result {
		log.Fatalf("failed to delete room id= %v", roomId)
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("failed to delete room")
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode("Successfully deleted")
}
