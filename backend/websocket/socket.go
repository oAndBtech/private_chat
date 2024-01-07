package websocket

import (
	"fmt"
	"net/http"
	"sync"

	"github.com/gorilla/websocket"
	"github.com/oAndBtech/private_chat/backend/database"
)

var (
	upgrader = websocket.Upgrader{
		CheckOrigin: func(r *http.Request) bool {
			return true
		},
	}
	clients      = make(map[string]map[*websocket.Conn]bool)
	clientsMutex sync.Mutex
)

func HandleConnections(w http.ResponseWriter, r *http.Request) {
	userID := r.URL.Query().Get("userId")
	roomID := r.URL.Query().Get("roomId")
	roomExists, err := database.VerifyRoomId(roomID)

	if err != nil {
		fmt.Println(err)
		return
	}

	if !roomExists {
		fmt.Println("WRONG ROOMID")
		return
	}

	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer conn.Close()

	fmt.Printf("%v User connected to the room: %v\n", userID, roomID)

	registerClient(roomID, conn)

	for {
		_, msg, err := conn.ReadMessage()
		if err != nil {
			fmt.Println(err)
			break
		}

		broadcast(roomID, conn, msg)
	}
}

func registerClient(roomID string, conn *websocket.Conn) {
	clientsMutex.Lock()
	defer clientsMutex.Unlock()

	if _, ok := clients[roomID]; !ok {
		clients[roomID] = make(map[*websocket.Conn]bool)
	}

	clients[roomID][conn] = true
}

func broadcast(roomID string, sender *websocket.Conn, message []byte) {
	clientsMutex.Lock()
	defer clientsMutex.Unlock()

	//TODO: send notification

	for conn := range clients[roomID] {
		if conn != sender {
			err := conn.WriteMessage(websocket.TextMessage, message)
			if err != nil {
				fmt.Println(err)
				conn.Close()
				delete(clients[roomID], conn)
			}
		}
	}
}
