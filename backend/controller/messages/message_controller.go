package controller

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/oAndBtech/private_chat/backend/database"
)

func MessagesInRoom(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	params := mux.Vars(r)
	roomId, ok := params["id"]

	if !ok {
		log.Fatal("Please provide a valid id")
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Please provide a valid id")
		return
	}

	messages,err := database.AllMessagesInRoom(roomId)

	if err!=nil{
		log.Fatalf("error while getting all messgaes in controller,%v",err)
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode("Failed to get all messages in room")
		return 
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(messages)
}


