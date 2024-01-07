package router

import (
	"github.com/gorilla/mux"
	"github.com/oAndBtech/private_chat/backend/websocket"
)

func Router() *mux.Router {

	r := mux.NewRouter()

	r.HandleFunc("/ws", websocket.HandleConnections)

	return r
}
